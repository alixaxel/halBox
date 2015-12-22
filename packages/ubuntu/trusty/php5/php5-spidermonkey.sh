#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libmozjs185-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/spidermonkey.ini ]]; then
    echo "" > /etc/php5/mods-available/spidermonkey.ini

    pear config-set php_ini /etc/php5/mods-available/spidermonkey.ini > /dev/null && yes "" | pecl -q install -f spidermonkey > /dev/null

    if [[ $(cat /etc/php5/mods-available/spidermonkey.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/spidermonkey.ini
    else
        php5enmod spidermonkey
    fi

    pear config-set php_ini "" > /dev/null
fi
