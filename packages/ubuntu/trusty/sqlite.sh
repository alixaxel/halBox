#!/usr/bin/env bash

wget -q http://www.sqlite.org/2015/sqlite-autoconf-3090200.tar.gz -O /tmp/sqlite-autoconf-3090200.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && tar -xf /tmp/sqlite-autoconf-3090200.tar.gz && cd /tmp/sqlite-autoconf-3090200 && ./configure --enable-fts5 --enable-json1 > /dev/null && make > /dev/null && make install > /dev/null
fi

cd ~ && rm -rf /tmp/sqlite-autoconf-3090200*
