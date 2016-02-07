#!/usr/bin/env bash

wget -q http://www.sqlite.org/2016/sqlite-autoconf-3100200.tar.gz -O /tmp/sqlite-autoconf-3100200.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && tar -xf /tmp/sqlite-autoconf-3100200.tar.gz && cd /tmp/sqlite-autoconf-3100200 && ./configure --enable-fts5 --enable-json1 > /dev/null && make > /dev/null && make install > /dev/null
fi

cd ~ && rm -rf /tmp/sqlite-autoconf-3100200*

if [[ -f /etc/init.d/php5-fpm ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'php5-fpm' service.\e[0m" && service php5-fpm restart > /dev/null
fi

if [[ -f /etc/init.d/php7.0-fpm ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'php7.0-fpm' service.\e[0m" && service php7.0-fpm restart > /dev/null
fi
