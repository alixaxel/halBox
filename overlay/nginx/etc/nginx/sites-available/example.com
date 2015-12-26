server {
    listen                      443 ssl http2;
    server_name                 cdn.example.com www.example.com;

    index                       index.html index.php;
    root                        /var/www/example.com/public;

    include                     /etc/nginx/conf.d/http_charset.conf;
    include                     /etc/nginx/conf.d/http_gzip.conf;
    include                     /etc/nginx/conf.d/http_gzip_static.conf;
    include                     /etc/nginx/conf.d/http_ssl.conf;

    ssl_certificate             /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key         /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate     /etc/letsencrypt/live/example.com/chain.pem;

    location / {
        try_files               $uri $uri/ /index.php?$query_string;                # $uri $uri/ @php @proxy
    }

    location @php {
        rewrite                 ^/(.*)/?$ /index.php/$1 last;
    }

    location @proxy {
        proxy_pass              http://localhost:3000;
        proxy_http_version      1.1;
        proxy_buffering         off;
        proxy_redirect          off;
        proxy_set_header        Host $host;
        proxy_set_header        Upgrade $http_upgrade;
        proxy_set_header        Connection $connection_upgrade;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
    }

    location ~* /(?:[.]|.*[.](?:bak|[a-z]?db|fla|in[ci]|log|phar|psd|sh|sql|sw[op])|(?:file|upload)s?/.*[.](?:php)) {
        deny                    all;
    }

    location ~* [.](?:php) {
        include                 /etc/nginx/conf.d/http_fastcgi.conf;
    }

    location ~* [.](?:atom|jsonp?|ow[lx]|rdf|rss|xml)$ {
        add_header              Cache-Control "public";
        expires                 1d;
    }

    location ~* [.](?:(?:css|js|less)|(?:eot|otf|tt[cf]|woff)|(?:cur|flv|gif|htc|ico|jpe?g|mp[34]|og[agv]|png|svgz?|swf|tiff?|web[mp]))$ {
        add_header              Cache-Control "public";
        expires                 1y;
    }

    location /favicon.ico {
        add_header              Cache-Control "public";
        expires                 1w;
        log_not_found           off;
    }

    error_page                  403 /error/403.html;
    error_page                  404 /error/404.html;
    error_page                  405 /error/405.html;
    error_page                  500 501 502 503 504 /error/5xx.html;

    location ^~ /error/ {
        internal;
        root                    /var/www/example.com;
    }

    location ^~ /.well-known/acme-challenge/ {
        root                    /var/www/example.com;
    }
}

server {
    listen                      80;
    server_name                 cdn.example.com;

    return                      301 https://cdn.example.com$request_uri;
}

server {
    listen                      80;
    server_name                 example.com www.example.com;

    return                      301 https://www.example.com$request_uri;
}

server {
    listen                      443 ssl http2;
    server_name                 example.com;

    include                     /etc/nginx/conf.d/http_ssl.conf;

    ssl_certificate             /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key         /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate     /etc/letsencrypt/live/example.com/chain.pem;

    return                      301 https://www.example.com$request_uri;
}
