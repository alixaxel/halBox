#!/usr/bin/env bash

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - > /dev/null

if [[ $? == 0 ]]; then
    if [[ ! -f /etc/apt/sources.list.d/postgresql.list ]]; then
        echo "deb http://apt.postgresql.org/pub/repos/apt/ $halBox_OS_Codename-pgdg main" > /etc/apt/sources.list.d/postgresql.list
    fi

    apt-get -qq update > /dev/null
fi

apt-get -qq install postgresql-9.5 postgresql-server-dev-9.5 > /dev/null 2>&1

if [[ $? == 0 ]]; then
    cp -r $halBox_Base/overlay/postgresql/. /etc/postgresql/[0..9]*/

su - postgres <<-EOF
    psql -c "CREATE ROLE root WITH SUPERUSER LOGIN ENCRYPTED PASSWORD '$halBox_PostgreSQL_password';" > /dev/null
EOF

    echo -e "\e[1;31mDave, your PostgreSQL root password is now '$halBox_PostgreSQL_password'.\e[0m"

    if [[ $halBox_PostgreSQL_networking == "1" ]]; then
        sed -i "s~#listen_addresses = 'localhost'~listen_addresses = '*'~" /etc/postgresql/[0..9]*/main/postgresql.conf && echo -e "\e[1;31mDave, remote PostgreSQL access is now enabled.\e[0m"
    else
        sed -i "s~#listen_addresses = 'localhost'~listen_addresses = 'localhost'~" /etc/postgresql/[0..9]*/main/postgresql.conf
    fi

    for halBox_PostgreSQL_package in pgcli pgloader pgtop pgtune; do
        echo -e "\e[1;32mDave, I'm also installing '$halBox_PostgreSQL_package'.\e[0m"

        if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/postgresql/$halBox_PostgreSQL_package.sh ]]; then
            source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/postgresql/$halBox_PostgreSQL_package.sh
        else
            apt-get -qq install $halBox_PostgreSQL_package > /dev/null
        fi
    done

    if [[ -f /etc/iptables.rules ]]; then
        sed -i -r "s~(--dport 5432) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
    fi
else
    echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
fi

if [[ -f /etc/init.d/postgresql ]]; then
    echo -e "\e[1;32mDave, I'm restarting the 'postgresql' service.\e[0m" && service postgresql restart > /dev/null
fi
