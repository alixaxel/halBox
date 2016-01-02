#!/usr/bin/env bash

apt-get -qq install zsh > /dev/null 2>&1

if [[ ! $(type -P git) ]]; then
    apt-get -qq install git > /dev/null
fi

if [[ $? == 0 ]]; then
    echo -e "\e[1;32mDave, I'm also installing 'oh-my-zsh'.\e[0m" && git clone -q git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh/

    if [[ $? == 0 ]]; then
        cp -r halBox-master/overlay/zsh/root/. ~/

        if [[ -n $SUDO_USER ]]; then
            chsh -s /bin/zsh "$SUDO_USER"
        else
            chsh -s /bin/zsh root
        fi

        echo -e "\e[1;31mDave, your default sheel is now ZSH - I suggest a reboot.\e[0m"
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
