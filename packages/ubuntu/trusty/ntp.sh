#!/usr/bin/env bash

apt-get -qq install ntp > /dev/null

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/ntp/. /

    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dport 123) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/ntp ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'ntp' service.\e[0m" && service ntp restart > /dev/null
fi
