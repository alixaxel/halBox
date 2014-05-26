#!/bin/bash

echo -e "\e[1;32mDave, I'm updating the package list...\e[0m" && apt-get -qq update > /dev/null && apt-get -qq install whiptail locales > /dev/null

if [[ $(type -P locale-gen) && $(type -P update-locale) ]]; then
	echo -e "\e[1;32mDave, I'm defaulting to the 'en_US.UTF-8' locale.\e[0m" && locale-gen en_US.UTF-8 > /dev/null && update-locale LANG=en_US.UTF-8
fi

for halBox_package in ack-grep bc bcrypt build-essential cloc curl dialog dstat host htop iftop ioping iotop jpegoptim nano ncdu optipng scrypt ssdeep strace tmux units unzip vim virt-what zip; do
	echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m" && apt-get -qq install $halBox_package > /dev/null
done

if [[ $(virt-what) == "virtualbox" && -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/virtualbox.sh ]]; then
	echo -e "\e[1;32mDave, I'm installing VirtualBox Guest Additions...\e[0m" && source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/virtualbox.sh
fi

echo -e "\e[1;32mDave, I'm defaulting to the UTC timezone.\e[0m" && echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1
