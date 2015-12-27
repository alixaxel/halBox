#!/usr/bin/env bash

halBox_Caddy_arch="386"

if [[ $halBox_Bits == "64" ]]; then
    halBox_Caddy_arch="amd64"
fi

wget -q "https://caddyserver.com/download/build?os=linux&arch=$halBox_Caddy_arch&features=cors,git,ipfilter,jsonp" -O /tmp/caddy.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && mkdir -p /tmp/caddy/ && tar -xf /tmp/caddy.tar.gz -C /tmp/caddy/ && mv /tmp/caddy/caddy /usr/local/sbin/caddy && chmod +x /usr/local/sbin/caddy

    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dport 2015) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
fi

cd ~ && rm -rf /tmp/caddy*
