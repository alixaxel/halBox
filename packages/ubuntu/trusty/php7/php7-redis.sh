#!/usr/bin/env bash

apt-get -qq install php7.0-dev re2c > /dev/null 2>&1

if [[ ! $(type -P git) ]]; then
    apt-get -qq install git > /dev/null
fi

git clone -q https://github.com/phpredis/phpredis.git /tmp/php-redis/

if [[ $? == 0 ]]; then
    cd /tmp/php-redis/ && git checkout -q php7 && phpize > /dev/null && ./configure > /dev/null && make > /dev/null && make install > /dev/null

    if [[ $? == 0 ]]; then
        echo "extension=redis.so" > /etc/php/mods-available/redis.ini
    fi
fi

if [[ $(cat /etc/php/mods-available/redis.ini | wc -c) -le 1 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m" && rm -f /etc/php/mods-available/redis.ini
else
    phpenmod -v ALL redis
fi

cd ~ && rm -rf /tmp/php-redis/
