#!/usr/bin/env bash

if [[ ! $(type -P gem) ]]; then
    apt-get -qq install ruby > /dev/null
fi

gem install scout_realtime > /dev/null

if [[ $? == 0 ]]; then
    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dport 5555) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
fi

