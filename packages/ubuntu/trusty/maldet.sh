#!/usr/bin/env bash

wget -q http://www.rfxn.com/downloads/maldetect-current.tar.gz -O /tmp/maldet.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && tar -xf /tmp/maldet.tar.gz && cd /tmp/maldetect-*/ && chmod +x ./install.sh && ./install.sh > /dev/null 2>&1
fi

cd ~ && rm -rf /tmp/maldet*
