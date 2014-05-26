#!/bin/bash

apt-get -qq install postgresql postgresql-client postgresql-contrib > /dev/null 2>&1

if [[ $? == 0 && -d $halBox_Base/config/postgresql/ ]]; then
	cp -r $halBox_Base/config/postgresql/* /etc/postgresql/[0..9]*/

	su - postgres <<-EOF
		psql -c "CREATE ROLE root WITH SUPERUSER LOGIN ENCRYPTED PASSWORD '$halBox_PostgreSQL_password';" > /dev/null
	EOF

	echo -e "\e[1;31mDave, your PostgreSQL root password is now '$halBox_PostgreSQL_password'.\e[0m"

	if [[ $halBox_PostgreSQL_networking == "1" ]]; then
		sed -i "s~#listen_addresses = 'localhost'~listen_addresses = '*'~" /etc/postgresql/[0..9]*/main/postgresql.conf && echo -e "\e[1;31mDave, remote PostgreSQL access is now enabled.\e[0m"
	else
		sed -i "s~#listen_addresses = 'localhost'~listen_addresses = 'localhost'~" /etc/postgresql/[0..9]*/main/postgresql.conf
	fi

	if [[ -f /etc/iptables.rules ]]; then
		sed -i -r "s~(--dport 5432) -j DROP~\1 -j ACCEPT~" /etc/iptables.rules && iptables-restore < /etc/iptables.rules
	fi
else
	echo -e "\e[1;31mSomething went wrong installing 'postgresql'.\e[0m"
fi

if [[ -f /etc/init.d/postgresql ]]; then
	echo -e "\e[1;32mDave, I'm restarting the 'postgresql' service.\e[0m" && service postgresql restart > /dev/null
fi
