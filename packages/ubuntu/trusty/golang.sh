#!/usr/bin/env bash

apt-get -qq install binutils bison gcc git make mercurial > /dev/null 2>&1
wget -q -O - https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash > /dev/null

if [[ -f ~/.gvm/scripts/gvm ]]; then
    source ~/.gvm/scripts/gvm && gvm install go1.4 > /dev/null && gvm use go1.4 > /dev/null && gvm install go1.5.2 > /dev/null && gvm use go1.5.2 --default > /dev/null && gvm uninstall go1.4 > /dev/null

    if [[ $? == 0 ]]; then
        mkdir -p ~/Go/{bin/,pkg/,src/}

        if [[ ! -d ~/Go/ ]]; then
            echo -e '\nexport GOPATH=$HOME/Go\nexport PATH=$PATH:$GOPATH/bin\n' >> ~/.profile
        fi
    fi
fi

if [[ ! -d ~/Go/ ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
