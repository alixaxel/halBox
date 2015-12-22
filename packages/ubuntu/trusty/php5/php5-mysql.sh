#!/usr/bin/env bash

apt-get -qq install php5-mysql > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/php5/mods-available/mysql.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'mysql' extension, you can re-enable it with:\n  php5enmod mysql\n\e[0m" && php5dismod mysql
    fi

    if [[ -f /etc/php5/mods-available/mysqli.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'mysqli' extension, you can re-enable it with:\n  php5enmod mysqli\n\e[0m" && php5dismod mysqli
    fi
else
    echo -e "\e[1;31mSomething went wrong installing 'php5-mysql'.\e[0m"
fi
