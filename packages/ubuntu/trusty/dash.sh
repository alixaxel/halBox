#!/bin/bash

apt-get -qq install dash > /dev/null

if [[ $? == 0 ]]; then
	if [[ -n $SUDO_USER ]]; then
		chsh -s /bin/dash "$SUDO_USER"
	else
		chsh -s /bin/dash root
	fi
else
	echo -e "\e[1;31mSomething went wrong installing 'dash'.\e[0m"
fi
