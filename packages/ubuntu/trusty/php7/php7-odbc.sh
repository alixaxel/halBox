#!/usr/bin/env bash

apt-get -qq install php7.0-odbc > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/php/mods-available/odbc.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'odbc' extension, you can re-enable it with:\n  phpenmod -v ALL odbc\n\e[0m" && phpdismod -v ALL odbc
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m"
fi
