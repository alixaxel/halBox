#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libevent-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/libevent.ini ]]; then
    echo "" > /etc/php5/mods-available/libevent.ini

    pear config-set php_ini /etc/php5/mods-available/libevent.ini > /dev/null && yes "" | pecl -q install -f libevent > /dev/null

    if [[ $(cat /etc/php5/mods-available/libevent.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/libevent.ini
    else
        php5enmod libevent
    fi

    pear config-set php_ini "" > /dev/null
fi
