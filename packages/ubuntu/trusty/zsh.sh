#!/usr/bin/env bash

apt-get -qq install git zsh > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -n $SUDO_USER ]]; then
        chsh -s /bin/zsh "$SUDO_USER"
    else
        chsh -s /bin/zsh root
    fi

    sh -c "$(wget -q https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" > /dev/null 2>&1

    if [[ $? == 0 ]]; then
        cp -r $halBox_Base/overlay/zsh/root/. ~/
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
