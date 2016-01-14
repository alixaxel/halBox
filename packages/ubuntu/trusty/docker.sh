#!/usr/bin/env bash

function version {
    echo "$@" | awk -F . '{ printf("%03d%03d%03d\n", $1,$2,$3); }';
}

if [[ $halBox_Bits -eq 64 ]]; then
    if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
        echo "deb https://apt.dockerproject.org/repo ubuntu-$halBox_OS_Codename main" > /etc/apt/sources.list.d/docker.list
    fi

    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D > /dev/null 2>&1

    if [[ $? == 0 ]]; then
        apt-get -qq update > /dev/null
    fi

    if [ $(version "$halBox_OS_Kernel") -lt $(version "3.10") ]; then
        echo -e "\e[1;31mDave, I'm upgrading the kernel.\e[0m" && apt-get -qq install linux-image-extra-$halBox_OS_Kernel > /dev/null
    fi

    apt-get -qq install docker-engine > /dev/null

    if [[ $? == 0 ]]; then
        if [[ -f /etc/default/docker ]]; then
            sed -i "s~#DOCKER_OPTS=~DOCKER_OPTS=~" /etc/default/docker
        fi
    else
        echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
    fi
else
    echo -e "\e[1;31mDave, '$halBox_package' requires a 64-bit installation.\e[0m"
fi

if [[ -f /etc/init.d/docker ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'docker' service.\e[0m" && service docker restart > /dev/null
fi
