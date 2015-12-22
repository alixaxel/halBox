#!/usr/bin/env bash

apt-get -qq install php5-librdf > /dev/null 2>&1

if [[ $? == 0 && -f /etc/php5/mods-available/redland.ini ]]; then
    php5enmod redland
else
    echo -e "\e[1;31mSomething went wrong installing 'php5-librdf'.\e[0m"
fi
