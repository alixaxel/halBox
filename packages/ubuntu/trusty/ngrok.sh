#!/usr/bin/env bash

wget -q https://dl.ngrok.com/ngrok_2.0.19_linux_$halBox_Arch.zip -O /tmp/ngrok.zip

if [[ $? == 0 ]]; then
    cd /tmp/ && unzip ngrok.zip > /dev/null && mv /tmp/ngrok /usr/local/sbin/ngrok && chmod +x /usr/local/sbin/ngrok
fi

cd ~ && rm -rf /tmp/ngrok*
