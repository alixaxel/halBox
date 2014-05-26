#!/bin/bash

apt-get -qq install ruby > /dev/null

if [[ $? == 0 ]]; then
	echo -e "\e[1;32mDave, I'm also installing 'rake'.\e[0m" && apt-get -qq install rake > /dev/null
else
	echo -e "\e[1;31mSomething went wrong installing 'ruby'.\e[0m"
fi
