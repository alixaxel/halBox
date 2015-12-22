#!/usr/bin/env bash

apt-get -qq install php5-sqlite > /dev/null 2>&1

if [[ $? == 0 ]]; then
    if [[ -f /etc/php5/mods-available/sqlite3.ini ]]; then
        echo -e "\e[1;32mDave, I'm disabling the non-PDO 'sqlite3' extension, you can re-enable it with:\n  php5enmod sqlite3\n\e[0m" && php5dismod sqlite3
    fi
else
    echo -e "\e[1;31mSomething went wrong installing 'php5-sqlite'.\e[0m"
fi
