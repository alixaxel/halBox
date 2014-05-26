#!/bin/bash

apt-get -qq install rsync > /dev/null 2>&1

if [[ $? == 0 && -d $halBox_Base/config/rsync/ ]]; then
	cp -r $halBox_Base/config/rsync/* / && chmod +x /usr/local/bin/{rsync_cp,rsync_mv,rsync_rm}
else
	echo -e "\e[1;31mSomething went wrong installing 'rsync'.\e[0m"
fi
