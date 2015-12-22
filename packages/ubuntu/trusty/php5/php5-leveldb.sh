#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! $(type -P git) ]]; then
    apt-get -qq install git > /dev/null
fi

apt-get -qq install libleveldb-dev > /dev/null

if [[ $(find /usr/lib/ -name libleveldb.so | wc -l) -eq 1 ]]; then
    git clone -q https://github.com/reeze/php-leveldb.git /tmp/php-leveldb/

    if [[ $? == 0 ]]; then
        cd /tmp/php-leveldb/ && phpize > /dev/null && ./configure --with-leveldb=$(dirname $(find /usr/lib/ -name libleveldb.so)) > /dev/null && make > /dev/null && make install > /dev/null

        if [[ $? == 0 ]]; then
            echo "extension=leveldb.so" > /etc/php5/mods-available/leveldb.ini
        fi
    fi
fi

if [[ $(cat /etc/php5/mods-available/leveldb.ini | wc -c) -le 1 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/leveldb.ini
else
    php5enmod leveldb
fi

cd ~ && rm -rf /tmp/php-leveldb/
