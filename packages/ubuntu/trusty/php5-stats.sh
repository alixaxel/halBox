#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/stats.ini ]]; then
	echo "" > /etc/php5/mods-available/stats.ini

	pear config-set php_ini /etc/php5/mods-available/stats.ini > /dev/null && printf "\n" | pecl -q install -f stats > /dev/null

	if [[ $(cat /etc/php5/mods-available/stats.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/stats.ini
	fi

	pear config-set php_ini "" > /dev/null
fi
