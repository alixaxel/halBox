#!/bin/bash

apt-get -qq install golang > /dev/null 2>&1

if [[ $? == 0 ]]; then
	if [[ ! -d ~/Go/ ]]; then
		echo "export GOPATH=~/Go" >> ~/.profile
	fi

	mkdir -p ~/Go/{bin/,pkg/,src/}
else
	echo -e "\e[1;31mSomething went wrong installing 'golang'.\e[0m"
fi
