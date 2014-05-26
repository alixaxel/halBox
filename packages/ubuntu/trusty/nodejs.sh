#!/bin/bash

apt-get -qq install nodejs npm > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'nodejs'.\e[0m"
fi
