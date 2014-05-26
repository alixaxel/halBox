#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev php5-curl libxml2-dev libcurl4-openssl-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/solr.ini ]]; then
	echo "" > /etc/php5/mods-available/solr.ini

	pear config-set php_ini /etc/php5/mods-available/solr.ini > /dev/null && printf "\n" | pecl -q install -f solr > /dev/null

	if [[ $(cat /etc/php5/mods-available/solr.ini | wc -c) -le 1 ]]; then
		echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/solr.ini
	else
		if [[ -d $halBox_Base/config/php5-solr/ ]]; then
			cp -r $halBox_Base/config/php5-solr/* /
		fi
	fi

	pear config-set php_ini "" > /dev/null
fi
