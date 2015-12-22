#!/usr/bin/env bash

apt-get -qq install php7.0-sqlite > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/php/mods-available/sqlite3.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'sqlite3' extension, you can re-enable it with:\n  phpenmod -v ALL sqlite3\n\e[0m" && phpdismod -v ALL sqlite3
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m"
fi
