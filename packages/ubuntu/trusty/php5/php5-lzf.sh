#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/lzf.ini ]]; then
    echo "" > /etc/php5/mods-available/lzf.ini

    pear config-set php_ini /etc/php5/mods-available/lzf.ini > /dev/null && yes "" | pecl -q install -f lzf > /dev/null

    if [[ $(cat /etc/php5/mods-available/lzf.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/lzf.ini
    else
        php5enmod lzf
    fi

    pear config-set php_ini "" > /dev/null
fi
