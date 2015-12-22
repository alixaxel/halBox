#!/usr/bin/env bash

if [[ ! -f /etc/apt/sources.list.d/nginx.list ]]; then
    echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list
fi

wget -q -O - http://nginx.org/packages/keys/nginx_signing.key | apt-key add - > /dev/null

if [[ $? == 0 ]]; then
    apt-get -qq update > /dev/null
fi

if [[ -f /etc/init.d/apache2 ]]; then
    echo -e "\e[1;32mDave, I'm uninstalling 'apache2'.\e[0m" && service apache2 stop && apt-get -qq remove --purge apache2 > /dev/null && rm -rf /var/www/html/
fi

apt-get -qq install nginx > /dev/null

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/nginx/* /

    if [[ -f /etc/nginx/nginx.conf ]]; then
        if [[ $halBox_CPU_Cores -gt 2 ]]; then
            sed -i -r "s~worker_processes([[:blank:]]*)[0-9]*;~worker_processes\1$halBox_CPU_Cores;~" /etc/nginx/nginx.conf
        fi
    fi

    for halBox_nginx_package in apache2-utils httperf letsencrypt ngxtop siege; do
        echo -e "\e[1;32mDave, I'm also installing '$halBox_nginx_package'.\e[0m"

        if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_nginx_package.sh ]]; then
            source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_nginx_package.sh
        else
            apt-get -qq install $halBox_nginx_package > /dev/null
        fi
    done

    chown -R www-data:www-data /var/{cache/nginx/,www/} && chmod +x /usr/local/sbin/{ngxdissite,ngxensite,ngxgzip}

    if [[ -n $SUDO_USER ]]; then
        usermod -a -G www-data "$SUDO_USER" && chgrp -R www-data /var/www/ && chmod -R g+rsw /var/www/
    fi

    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dports 80,443) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/nginx ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'nginx' service.\e[0m" && service nginx restart > /dev/null
fi
