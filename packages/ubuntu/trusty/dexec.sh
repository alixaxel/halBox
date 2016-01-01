#!/usr/bin/env bash

wget -q https://bintray.com/artifact/download/dexec/release/dexec_1.0.3_linux_$halBox_Arch.tar.gz -O /tmp/dexec.tar.gz

if [[ $? == 0 ]]; then
    cd /tmp/ && mkdir -p /tmp/dexec/ && tar -xf /tmp/dexec.tar.gz -C /tmp/dexec/ && mv /tmp/dexec/*/dexec /usr/local/sbin/dexec && chmod +x /usr/local/sbin/dexec
fi

cd ~ && rm -rf /tmp/dexec*
