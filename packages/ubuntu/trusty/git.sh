#!/usr/bin/env bash

apt-get -qq install git > /dev/null

if [[ $? == 0 ]]; then
    echo -e "\e[1;32mDave, I'm also installing 'hub'.\e[0m" && apt-get -qq install ruby > /dev/null && wget -q http://hub.github.com/standalone -O /usr/local/bin/hub && chmod +x /usr/local/bin/hub
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
