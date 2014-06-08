#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/stem.ini ]]; then
	echo "" > /etc/php5/mods-available/stem.ini

	pear config-set php_ini /etc/php5/mods-available/stem.ini > /dev/null && printf "\n" | pecl -q install -f stem > /dev/null

	if [[ $(cat /etc/php5/mods-available/stem.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/stem.ini
	fi

	pear config-set php_ini "" > /dev/null
fi