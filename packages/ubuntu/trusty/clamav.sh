#!/usr/bin/env bash

apt-get -qq install clamav clamav-freshclam > /dev/null 2>&1

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/clamav/. /

    if [[ -f /etc/cron.daily/clamav ]]; then
        chmod +x /etc/cron.daily/clamav
    fi

    if [[ -d /var/quarantine/ ]]; then
        chmod -R 0600 /var/quarantine/
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
