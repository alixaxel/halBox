#!/usr/bin/env bash

echo -e "\e[1;32mDave, I'm updating the package list...\e[0m" && apt-get -qq update > /dev/null && apt-get -qq install whiptail locales > /dev/null

if ! grep -q "LC_ALL" /etc/default/locale; then
    echo -e "\e[1;32mDave, I'm defaulting to the 'en_US.UTF-8' locale.\e[0m" && echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale && locale-gen en_US.UTF-8 > /dev/null && export LC_ALL=en_US.UTF-8
fi

for halBox_package in ack-grep bc bcrypt build-essential cloc curl dialog dstat host htop iftop ioping iotop jpegoptim nano ncdu ntp optipng scrypt ssdeep strace tmux units unzip vim virt-what zip; do
    echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m" && apt-get -qq install $halBox_package > /dev/null
done

if [[ $(virt-what) == "virtualbox" && -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/virtualbox.sh ]]; then
    echo -e "\e[1;32mDave, I'm installing VirtualBox Guest Additions...\e[0m" && source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/virtualbox.sh
fi

echo -e "\e[1;32mDave, I'm defaulting to the UTC timezone.\e[0m" && echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1

if [[ $(ulimit -n) -le 65536 ]]; then
    echo -e "\e[1;32mDave, I'm increasing the maximum number of open files to 65536.\e[0m"

    if [[ ! -f /etc/sysctl.d/60-file-max.conf ]]; then
        echo 'fs.file-max = 65536' >> /etc/sysctl.d/60-file-max.conf
    fi

    if [[ ! -f /etc/security/limits.d/60-nofile-limit.conf ]]; then
        echo "*       soft    nofile    65536" >> /etc/security/limits.d/60-nofile-limit.conf
        echo "*       hard    nofile    65536" >> /etc/security/limits.d/60-nofile-limit.conf
        echo "root    soft    nofile    65536" >> /etc/security/limits.d/60-nofile-limit.conf
        echo "root    hard    nofile    65536" >> /etc/security/limits.d/60-nofile-limit.conf
    fi

    ulimit -n 65536
fi
