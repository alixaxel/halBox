#!/bin/bash

apt-get -qq install php5-pgsql > /dev/null 2>&1

if [[ $? == 0 ]]; then
	if [[ -f /etc/php5/mods-available/pgsql.ini ]]; then
		echo -e "\e[1;32mDave, I'm disabling the non-PDO 'pgsql' extension, you can re-enable it with:\n  php5enmod pgsql\n\e[0m" && php5dismod pgsql
	fi
else
	echo -e "\e[1;31mSomething went wrong installing 'php5-pgsql'.\e[0m"
fi
