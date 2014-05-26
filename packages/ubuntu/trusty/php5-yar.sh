#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libcurl4-openssl-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/yar.ini ]]; then
	echo "" > /etc/php5/mods-available/yar.ini

	pear config-set php_ini /etc/php5/mods-available/yar.ini > /dev/null && printf "\n" | pecl -q install -f yar > /dev/null

	if [[ $(cat /etc/php5/mods-available/yar.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/yar.ini
	else
		if [[ -d $halBox_Base/config/php5-yar/ ]]; then
			cp -r $halBox_Base/config/php5-yar/* /
		fi
	fi

	pear config-set php_ini "" > /dev/null
fi
