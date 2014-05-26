#!/bin/bash

apt-get -qq install freetds-bin freetds-dev tdsodbc unixodbc unixodbc-dev php5-mssql > /dev/null 2>&1

if [[ $? == 0 ]]; then
	if [[ -f /etc/php5/mods-available/mssql.ini ]]; then
		echo -e "\e[1;32mDave, I'm disabling the non-PDO 'mssql' extension, you can re-enable it with:\n  php5enmod mssql\n\e[0m" && php5dismod mssql
	fi
fi
