#!/usr/bin/env bash

add-apt-repository -y ppa:chris-lea/redis-server > /dev/null 2>&1

if [[ $? == 0 ]]; then
    apt-get -qq update > /dev/null
fi

apt-get -qq install redis-server > /dev/null

if [[ $? != 0 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
