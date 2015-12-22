#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libfann-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/fann.ini ]]; then
    echo "" > /etc/php5/mods-available/fann.ini

    pear config-set php_ini /etc/php5/mods-available/fann.ini > /dev/null && yes "" | pecl -q install -f fann > /dev/null

    if [[ $(cat /etc/php5/mods-available/fann.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/fann.ini
    else
        php5enmod fann
    fi

    pear config-set php_ini "" > /dev/null
fi
