#!/usr/bin/env bash

wget -q http://innotop.googlecode.com/files/innotop-1.9.0.tar.gz -O /tmp/innotop.tar.gz

if [[ $? == 0 ]]; then
    apt-get -qq install libdbd-mysql-perl libdbi-perl libterm-readkey-perl > /dev/null

    if [[ $? == 0 ]]; then
        cd /tmp/ && tar -xf /tmp/innotop.tar.gz && cd /tmp/innotop-*/ && perl ./Makefile.PL > /dev/null && make install > /dev/null

        if [[ -f /usr/local/bin/innotop ]]; then
            chmod +x /usr/local/bin/innotop
        fi
    fi
fi

cd ~ && rm -rf /tmp/innotop*
