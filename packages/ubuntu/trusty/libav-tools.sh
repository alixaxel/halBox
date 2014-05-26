#!/bin/bash

apt-get -qq install libav-tools > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'libav-tools'.\e[0m"
fi
