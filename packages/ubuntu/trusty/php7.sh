#!/usr/bin/env bash

add-apt-repository -y ppa:ondrej/php-7.0 > /dev/null 2>&1

if [[ $? == 0 ]]; then
    apt-get -qq update > /dev/null
fi

apt-get -qq install php7.0-cli php7.0-fpm > /dev/null 2>&1

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/php/. / && cp -r $halBox_Base/overlay/php7/. /

    if [[ -f /etc/php/mods-available/halBox-dev.ini ]]; then
        phpenmod -v ALL halBox-dev
    fi

    if [[ -f /etc/php/7.0/fpm/pool.d/www.conf ]]; then
        sed -i "s~listen =.*~listen = 127.0.0.1:9000~" /etc/php/7.0/fpm/pool.d/www.conf
        sed -i "s~;listen.allowed_clients~listen.allowed_clients~" /etc/php/7.0/fpm/pool.d/www.conf
    fi

    for halBox_PHP7_package in $halBox_PHP7_packages; do
        echo -e "\e[1;32mDave, I'm installing '$halBox_PHP7_package'.\e[0m"

        if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/php7/$halBox_PHP7_package.sh ]]; then
            source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/php7/$halBox_PHP7_package.sh
        else
            apt-get -qq install $halBox_PHP7_package > /dev/null 2>&1

            if [[ $? != 0 ]]; then
                echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP7_package'.\e[0m"
            elif [[ -f /etc/php/mods-available/${halBox_PHP7_package:5}.ini ]]; then
                sed -i "s~^#~;~" /etc/php/mods-available/${halBox_PHP7_package:5}.ini && phpenmod -v ALL ${halBox_PHP7_package:5}
            fi
        fi
    done

    if [[ -f /etc/init.d/nginx ]]; then
        echo -e "\e[1;32mDave, I'm also installing 'adminer'.\e[0m" && wget -q https://www.adminer.org/latest.php -O /var/www/default/public/adminer/adminer.php && wget -q https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php -O /var/www/default/public/adminer/plugins/plugin.php
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/php7.0-fpm ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'php7.0-fpm' service.\e[0m" && service php7.0-fpm restart > /dev/null

    if [[ -f /etc/init.d/nginx ]]; then
        echo -e "\e[1;32mDave, I'm restarting the 'nginx' service.\e[0m" && service nginx restart > /dev/null
    fi
fi
