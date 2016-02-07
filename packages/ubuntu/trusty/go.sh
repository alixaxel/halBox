#!/usr/bin/env bash

apt-get -qq install binutils bison gcc git make mercurial > /dev/null 2>&1
wget -q https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -O - | bash > /dev/null

if [[ -f ~/.gvm/scripts/gvm ]]; then
    source ~/.gvm/scripts/gvm && gvm install go1.4 > /dev/null && gvm use go1.4 > /dev/null && gvm install go1.5.3 > /dev/null && gvm use go1.5.3 --default > /dev/null && gvm uninstall go1.4 > /dev/null

    if [[ $? == 0 ]]; then
        mkdir -p ~/Go/{bin/,pkg/,src/}

        if [[ ! -f /etc/profile.d/go.sh ]]; then
            echo -e 'export GO15VENDOREXPERIMENT=1\nexport GOROOT_BOOTSTRAP=$GOROOT\nexport GOPATH=$HOME/Go\nexport PATH=$PATH:$GOPATH/bin\n' > /etc/profile.d/go.sh && source /etc/profile.d/go.sh
        fi

        for halBox_Go_package in devd errcheck glide godef godep godepgraph godoc goimports gometalinter gox goxc interfacer jsonf oracle penv; do
            if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/go/$halBox_Go_package.sh ]]; then
                echo -e "\e[1;32mDave, I'm also installing '$halBox_Go_package'.\e[0m" && source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/go/$halBox_Go_package.sh
            fi
        done
    fi
fi

if [[ ! -d ~/Go/ ]]; then
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
