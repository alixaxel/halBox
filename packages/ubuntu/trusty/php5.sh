#!/usr/bin/env bash

apt-get -qq install php5-cli php5-fpm > /dev/null 2>&1

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/php/* / && cp -r $halBox_Base/overlay/php5/* /

    if [[ -f /etc/php5/mods-available/halBox-dev.ini ]]; then
        php5enmod halBox-dev
    fi

    if [[ -f /etc/php5/fpm/pool.d/www.conf ]]; then
        sed -i "s~listen =.*~listen = 127.0.0.1:9000~" /etc/php5/fpm/pool.d/www.conf
        sed -i "s~;listen.allowed_clients~listen.allowed_clients~" /etc/php5/fpm/pool.d/www.conf
    fi

    for halBox_PHP5_package in $halBox_PHP5_packages; do
        echo -e "\e[1;32mDave, I'm installing '$halBox_PHP5_package'.\e[0m"

        if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/php5/$halBox_PHP5_package.sh ]]; then
            source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/php5/$halBox_PHP5_package.sh
        else
            apt-get -qq install $halBox_PHP5_package > /dev/null 2>&1

            if [[ $? != 0 ]]; then
                echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m"
            elif [[ -f /etc/php5/mods-available/${halBox_PHP5_package:5}.ini ]]; then
                sed -i "s~^#~;~" /etc/php5/mods-available/${halBox_PHP5_package:5}.ini && php5enmod ${halBox_PHP5_package:5}
            fi
        fi
    done

    if [[ -f /etc/init.d/nginx ]]; then
        echo -e "\e[1;32mDave, I'm also installing 'adminer'.\e[0m" && wget -q http://sourceforge.net/projects/adminer/files/latest/download -O /var/www/localhost/public/adminer/adminer.php
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/php5-fpm ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'php5-fpm' service.\e[0m" && service php5-fpm restart > /dev/null

    if [[ -f /etc/init.d/nginx ]]; then
        echo -e "\e[1;32mDave, I'm restarting the 'nginx' service.\e[0m" && service nginx restart > /dev/null
    fi
fi
