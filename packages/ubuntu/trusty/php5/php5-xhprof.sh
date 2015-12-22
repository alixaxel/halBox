#!/usr/bin/env bash

apt-get -qq install php5-xhprof > /dev/null 2>&1

if [[ $? == 0 && -f /etc/php5/mods-available/xhprof.ini ]]; then
    php5enmod xhprof
else
    echo -e "\e[1;31mSomething went wrong installing 'php5-xhprof'.\e[0m"
fi
