#!/usr/bin/env bash

apt-get -qq install php7.0-dev re2c > /dev/null 2>&1
wget -q https://pecl.php.net/get/timezonedb -O /tmp/timezonedb.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && mkdir -p /tmp/timezonedb/ && tar -xf /tmp/timezonedb.tar.gz -C /tmp/timezonedb/ && cd /tmp/timezonedb/timezonedb-*/ && phpize > /dev/null && ./configure > /dev/null && make > /dev/null 2>&1 && make install > /dev/null

    if [[ $? == 0 ]]; then
        echo "extension=timezonedb.so" > /etc/php/mods-available/timezonedb.ini
    fi
fi

if [[ $(cat /etc/php/mods-available/timezonedb.ini | wc -c) -le 1 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m" && rm -f /etc/php/mods-available/timezonedb.ini
else
    phpenmod -v ALL timezonedb
fi

cd ~ && rm -rf /tmp/timezonedb*
