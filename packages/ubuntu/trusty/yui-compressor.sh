#!/bin/bash

apt-get -qq install yui-compressor > /dev/null 2>&1

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'yui-compressor'.\e[0m"
fi
