#!/usr/bin/env bash

if [[ ! -f /etc/apt/sources.list.d/mariadb.list ]]; then
    echo "deb http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu $halBox_OS_Codename main" > /etc/apt/sources.list.d/mariadb.list
fi

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xcbcb082a1bb943db > /dev/null 2>&1

if [[ $? == 0 ]]; then
    apt-get -qq update > /dev/null
fi

cp -r $halBox_Base/overlay/mysql/* / && DEBIAN_FRONTEND=noninteractive apt-get -qq install expect mariadb-server mariadb-client > /dev/null 2>&1

if [[ $? == 0 ]]; then
    chmod +x $halBox_Base/bin/mysql_secure_installation.sh && expect -f $halBox_Base/bin/mysql_secure_installation.sh $halBox_MySQL_password > /dev/null

    if [[ -f ~/.my.cnf ]]; then
        sed -i -r "s~^password([[:blank:]]*)=$;~password\1= $halBox_MySQL_password;~" ~/.my.cnf && chmod 0600 ~/.my.cnf
    fi

    echo -e "\e[1;31mDave, your MariaDB root password is now '$halBox_MySQL_password'.\e[0m"

    if [[ $halBox_MySQL_networking == "1" ]]; then
        mysql --user="root" --password="$( printf "%q" "$halBox_MySQL_password")" -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$(printf "%q" "$halBox_MySQL_password")' WITH GRANT OPTION; FLUSH PRIVILEGES;"

        if [[ $? == 0 ]]; then
            sed -i "s~skip-networking~#skip-networking~" /etc/mysql/conf.d/halBox.cnf && echo -e "\e[1;31mDave, remote MariaDB access is now enabled.\e[0m"
        fi
    fi

    if [[ $halBox_RAM -ge 512 ]]; then
        sed -i "s~skip-innodb~#skip-innodb~" /etc/mysql/conf.d/halBox.cnf && echo -e "\e[1;31mDave, MariaDB InnoDB storage engine is now enabled.\e[0m"
    fi

    for halBox_MySQL_package in innotop mysqltuner tuning-primer; do
        echo -e "\e[1;32mDave, I'm also installing '$halBox_MySQL_package'.\e[0m"

        if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_MySQL_package.sh ]]; then
            source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_MySQL_package.sh
        else
            apt-get -qq install $halBox_MySQL_package > /dev/null
        fi
    done

    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dport 3306) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/mysql ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'mysql' service.\e[0m" && service mysql restart > /dev/null
fi
