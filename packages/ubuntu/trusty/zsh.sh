#!/usr/bin/env bash

apt-get -qq install git zsh > /dev/null 2>&1

if [[ $? == 0 ]]; then
    echo -e "\e[1;32mDave, I'm also installing 'direnv'.\e[0m" && wget -q https://github.com/direnv/direnv/releases/download/v2.6.0/direnv.linux-$halBox_Arch -O /usr/local/bin/direnv && chmod +x /usr/local/bin/direnv

    if [[ -n $SUDO_USER ]]; then
        chsh -s /bin/zsh "$SUDO_USER"
    else
        chsh -s /bin/zsh root
    fi

    echo -e "\e[1;32mDave, I'm also installing 'oh-my-zsh'.\e[0m" && sh -c "$(wget -q https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" > /dev/null 2>&1

    if [[ -d ~/.oh-my-zsh/ ]]; then
        cp -r $halBox_Base/overlay/zsh/root/. ~/ && source ~/.zprofile
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
