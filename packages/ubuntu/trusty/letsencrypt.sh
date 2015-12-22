#!/usr/bin/env bash

if [[ ! $(type -P git) ]]; then
    apt-get -qq install git > /dev/null
fi

git clone -q https://github.com/letsencrypt/letsencrypt ~/.letsencrypt

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/letsencrypt/* /

    if [[ -f /etc/letsencrypt/letsencrypt.ini ]]; then
        if [[ $halBox_LetsEncrypt_email == *"@"* ]]; then
            sed -i -r "s~^email([[:blank:]]*)=$~email\1= $halBox_LetsEncrypt_email~" /etc/letsencrypt/letsencrypt.ini
        else
            sed -i -r "s~^# register-unsafely-without-email$~register-unsafely-without-email~" /etc/letsencrypt/letsencrypt.ini
        fi
    fi

    if [[ -f /etc/cron.monthly/letsencrypt ]]; then
        chmod +x /etc/cron.monthly/letsencrypt
    fi
fi
