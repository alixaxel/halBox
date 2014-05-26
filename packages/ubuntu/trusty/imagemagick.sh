#!/bin/bash

apt-get -qq install imagemagick > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'imagemagick'.\e[0m"
fi
