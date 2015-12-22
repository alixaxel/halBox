#!/usr/bin/env bash

apt-get -qq install php5-odbc > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/php5/mods-available/odbc.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'odbc' extension, you can re-enable it with:\n  php5enmod odbc\n\e[0m" && php5dismod odbc
    fi
else
    echo -e "\e[1;31mSomething went wrong installing 'php5-odbc'.\e[0m"
fi
