#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libcurl4-openssl-dev libevent-dev libmagic-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/http.ini ]]; then
    echo "" > /etc/php5/mods-available/http.ini

    pear config-set php_ini /etc/php5/mods-available/http.ini > /dev/null && yes "" | pecl -q install -f pecl_http > /dev/null

    if [[ $(cat /etc/php5/mods-available/http.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/http.ini
    else
        cp -r $halBox_Base/overlay/php5-http/. / && php5enmod http
    fi

    pear config-set php_ini "" > /dev/null
fi
