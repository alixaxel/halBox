#!/usr/bin/env bash

apt-get -qq install iptables > /dev/null

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/iptables/* / && chmod +x /etc/network/if-pre-up.d/iptables && iptables-restore < /etc/iptables.rules
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
