#!/usr/bin/env bash

if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
fi

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D > /dev/null 2>&1

if [[ $? == 0 ]]; then
    apt-get -qq update > /dev/null
fi

apt-get -qq install linux-image-extra-$(uname -r) docker-engine > /dev/null

if [[ -f /etc/default/docker ]]; then
    sed -i "s~#DOCKER_OPTS=~DOCKER_OPTS=~" /etc/default/docker
fi

if [[ -f /etc/init.d/docker ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'docker' service.\e[0m" && service docker restart > /dev/null
fi
