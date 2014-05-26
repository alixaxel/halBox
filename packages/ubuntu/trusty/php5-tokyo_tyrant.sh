#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev pkg-config libtokyotyrant-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/tokyo_tyrant.ini ]]; then
	echo "" > /etc/php5/mods-available/tokyo_tyrant.ini

	pear config-set php_ini /etc/php5/mods-available/tokyo_tyrant.ini > /dev/null && printf "\n" | pecl -q install -f tokyo_tyrant > /dev/null

	if [[ $(cat /etc/php5/mods-available/tokyo_tyrant.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/tokyo_tyrant.ini
	fi

	pear config-set php_ini "" > /dev/null
fi
