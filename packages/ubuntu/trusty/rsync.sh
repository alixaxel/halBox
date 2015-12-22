#!/usr/bin/env bash

apt-get -qq install rsync > /dev/null 2>&1

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/rsync/* / && chmod +x /usr/local/bin/{rsync_cp,rsync_mv,rsync_rm}
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi
