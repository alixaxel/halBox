#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev libevent-dev libssl-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/event.ini ]]; then
	echo "" > /etc/php5/mods-available/event.ini

	pear config-set php_ini /etc/php5/mods-available/event.ini > /dev/null && printf "\n" | pecl -q install -f event > /dev/null

	if [[ $(cat /etc/php5/mods-available/event.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/event.ini
	fi

	pear config-set php_ini "" > /dev/null
fi
