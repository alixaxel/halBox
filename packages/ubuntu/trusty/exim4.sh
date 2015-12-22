#!/usr/bin/env bash

apt-get -qq install exim4 > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/exim4/update-exim4.conf.conf ]]; then
        sed -i "s~dc_eximconfig_configtype='local'~dc_eximconfig_configtype='internet'~" /etc/exim4/update-exim4.conf.conf
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/exim4 ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'exim4' service.\e[0m" && service exim4 restart > /dev/null
fi
