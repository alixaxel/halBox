#!/bin/bash

apt-get -qq install rkhunter > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'rkhunter'.\e[0m"
fi
