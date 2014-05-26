#!/bin/bash

apt-get -qq install zsh > /dev/null 2>&1

if [[ $? == 0 ]]; then
	if [[ -n $SUDO_USER ]]; then
		chsh -s /bin/zsh "$SUDO_USER"
	else
		chsh -s /bin/zsh root
	fi
else
	echo -e "\e[1;31mSomething went wrong installing 'zsh'.\e[0m"
fi
