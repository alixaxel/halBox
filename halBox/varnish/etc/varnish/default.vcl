backend nginx {
	.host = "127.0.0.1";
	.port = "8000";
}

acl purge {
	"localhost";
	"127.0.0.1";
}

sub vcl_recv {
	if (req.url ~ "[.](jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|pdf|txt|tar|wav|bmp|rtf|js|flv|swf|html|htm)$") {
		unset req.http.Cookie; return(lookup);
	}

	set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|has_js)=[^;]*", "");
	set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");

	if (req.http.Cookie ~ "^\s*$") {
		unset req.http.Cookie;
	}

	if (req.request == "PURGE") {
		if (!client.ip ~ purge) {
			error 405 "Not allowed.";
		}

		purge("req.url ~ " req.url " && req.http.host == " req.http.host);
		error 200 "Purged.";
	}
}

sub vcl_hash {
	if (req.http.Cookie) {
		set req.hash += req.http.Cookie;
	}
}

sub vcl_fetch {
	if (req.url ~ "\.(jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|pdf|txt|tar|wav|bmp|rtf|js|flv|swf|html|htm)$") {
		unset beresp.http.set-cookie;
	}

	if (!beresp.cacheable) {
		set beresp.http.X-Cacheable = "NO:Not Cacheable";
	}

	elsif (req.http.Cookie ~"(UserID|_session)") {
		set beresp.http.X-Cacheable = "NO:Got Session";
		return(pass);
	}

	elsif (beresp.http.Cache-Control ~ "private") {
		set beresp.http.X-Cacheable = "NO:Cache-Control=private";
		return(pass);
	}

	elsif ( beresp.ttl < 1s ) {
		set beresp.ttl   = 300s;
		set beresp.grace = 300s;
		set beresp.http.X-Cacheable = "YES:Forced";
	}

	else {
		set beresp.http.X-Cacheable = "YES";
	}

	return(deliver);
}
