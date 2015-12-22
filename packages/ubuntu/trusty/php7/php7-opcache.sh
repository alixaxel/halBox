#!/usr/bin/env bash

apt-get -qq install php7.0-opcache > /dev/null 2>&1

if [[ $? != 0 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m"
fi
