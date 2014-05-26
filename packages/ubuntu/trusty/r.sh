#!/bin/bash

apt-get -qq install r-base > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'r'.\e[0m"
fi
