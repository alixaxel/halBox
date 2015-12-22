#!/usr/bin/env bash

apt-get -qq install golang > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ ! -d ~/Go/ ]]; then
        echo -e '\nexport GOPATH=$HOME/Go\nexport PATH=$PATH:$GOPATH/bin\n' >> ~/.profile
    fi

    mkdir -p ~/Go/{bin/,pkg/,src/}
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
