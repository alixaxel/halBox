#!/bin/bash

apt-get -qq install iptables > /dev/null

if [[ $? == 0 && -d $halBox_Base/config/iptables/ ]]; then
	cp -r $halBox_Base/config/iptables/* / && chmod +x /etc/network/if-pre-up.d/iptables && iptables-restore < /etc/iptables.rules
else
	echo -e "\e[1;31mSomething went wrong installing 'iptables'.\e[0m"
fi
