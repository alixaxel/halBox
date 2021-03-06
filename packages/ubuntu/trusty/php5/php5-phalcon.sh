#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! $(type -P git) ]]; then
    apt-get -qq install git > /dev/null
fi

git clone -q --depth=1 git://github.com/phalcon/cphalcon.git /tmp/php-phalcon/

if [[ $? == 0 ]]; then
    cd /tmp/php-phalcon/build && ./install > /dev/null 2>&1

    if [[ $? == 0 ]]; then
        echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
    fi
fi

if [[ $(cat /etc/php5/mods-available/phalcon.ini | wc -c) -le 1 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/phalcon.ini
else
    php5enmod phalcon
fi

cd ~ && rm -rf /tmp/php-phalcon/
