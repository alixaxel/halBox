#!/usr/bin/env bash

apt-get -qq install nodejs npm > /dev/null 2>&1

if [[ $? != 0 ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
