#!/usr/bin/env bash

wget -q https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O - | apt-key add - > /dev/null

if [[ $? == 0 ]]; then
    if [[ ! -f /etc/apt/sources.list.d/nodejs.list ]]; then
        echo "deb https://deb.nodesource.com/node_5.x $halBox_OS_Codename main" > /etc/apt/sources.list.d/nodejs.list
    fi

    apt-get -qq update > /dev/null
fi

apt-get -qq install nodejs > /dev/null 2>&1

if [[ $? == 0 ]]; then
    echo -e 'export NODE_PATH=/usr/lib/nodejs:/usr/lib/node_modules\n' > /etc/profile.d/nodejs.sh && source /etc/profile.d/nodejs.sh

    for halBox_NodeJS_package in bower browserify coffee-script express forever grunt grunt-cli gulp nixar pm2 yo; do
        echo -e "\e[1;32mDave, I'm also installing '$halBox_NodeJS_package'.\e[0m" && npm install --global $halBox_NodeJS_package > /dev/null 2>&1
    done
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
