#!/bin/bash

apt-get -qq install redis-server > /dev/null

if [[ $? != 0 ]]; then
	echo -e "\e[1;31mSomething went wrong installing 'redis'.\e[0m"
fi
