#!/bin/bash

clear && echo -e "\e[1;31mhalBox 0.20.0\e[0m\n"

if [[ $( whoami ) != "root" ]]; then
	echo -e "\e[1;31mDave, is that you?\e[0m" && exit 1
fi

if [[ ! -f /etc/debian_version ]]; then
	echo -e "\e[1;31mI think you know what the problem is just as well as I do.\e[0m" && exit 1
else
	halBox_CPU=$( grep -h "^physical id" /proc/cpuinfo | sort -u | wc -l )
	halBox_CPU_Cache=$( grep -h "^cache size" /proc/cpuinfo | sort -u | awk '{ print int($4 / 1024) }' )
	halBox_CPU_Cores=$( grep -h "^core id" /proc/cpuinfo | sort -u | wc -l )
	halBox_OS=$( lsb_release -si | awk '{ print tolower($0) }' )
	halBox_OS_Codename=$( lsb_release -sc )
	halBox_OS_Release=$( lsb_release -sr )
	halBox_RAM=$( grep -h "^MemTotal:" /proc/meminfo | awk '{ print int($2 / 1024) }' )
	halBox_RAM_Free=$( grep -h "^MemFree:" /proc/meminfo | awk '{ print int($2 / 1024) }' )
fi

if [[ $halBox_OS == "debian" ]]; then
	if [[ ! -f /etc/apt/sources.list.d/dotdeb.list ]]; then
		echo -e "deb http://packages.dotdeb.org/ $halBox_OS_Codename all\n" > /etc/apt/sources.list.d/dotdeb.list
	fi

	echo -e "\e[1;32mDave, I'm adding the DotDeb repository.\e[0m" && ( wget -q http://www.dotdeb.org/dotdeb.gpg -O - | apt-key add - ) > /dev/null 2>&1
else [[ $halBox_OS == "ubuntu" ]]; then
	if [[ ! $( type -P add-apt-repository ) ]]; then
		echo -e "\e[1;32mDave, hold on...\e[0m" && ( apt-get -qq -y update && apt-get -qq -y install python-software-properties ) > /dev/null
	fi

	for halBox_PPA in chris-lea/node.js ondrej/php5; do
		echo -e "\e[1;32mDave, I'm adding the $halBox_PPA PPA.\e[0m" && ( add-apt-repository -y ppa:$halBox_PPA ) > /dev/null 2>&1
	done
fi

echo -e "\e[1;32mDave, I'm updating the repositories...\e[0m" && ( apt-get -qq -y update && apt-get -qq -y upgrade && apt-get -qq -y install dialog ) > /dev/null 2>&1

if [[ ! $( type -P dialog ) ]]; then
	echo -e "\e[1;31mI'm sorry, Dave. I'm afraid I can't do that.\e[0m" && exit 1
fi

exec 3>&1

halBox_packages=$( dialog \
	--cancel-label "Nevermind HAL" \
	--ok-label "Okay" \
	--separate-output \
	--title "halBox" \
	--checklist "Dave, select the packages to install." 0 0 0 \
		aptitude "terminal-based package manager" off \
		chkrootkit "rootkit detector" off \
		clamav "anti-virus utility for Unix" off \
		curl "client URL" on \
		dash "POSIX-compliant shell" off \
		dropbear "lightweight SSH2 server and client" on \
		exim4 "mail transport agent" on \
		git-core "distributed revision control system" off \
		htop "interactive processes viewer" on \
		httperf "HTTP server performance tester" off \
		iftop "displays bandwidth usage information" on \
		inetutils-syslogd "system logging daemon" on \
		innotop "powerful top clone for MySQL" off \
		iotop "simple top-like I/O monitor" on \
		iptables "tools for packet filtering and NAT" on \
		maldet "linux malware scanner" off \
		mc "powerful file manager " off \
		memcached "high-performance memory object caching system" off \
		meteor "platform for building HTML5 websites in JavaScript" off \
		mongodb-server "object/document-oriented database" off \
		mysql "MySQL database server and client" on \
		nano "small, friendly text editor" on \
		nginx "small, powerful & scalable web/proxy server" on \
		nodejs "event-based server-side JavaScript engine" off \
		ntp "network time protocol deamon" off \
		openjdk-7-jre "OpenJDK Java runtime" off \
		php "server-side, HTML-embedded scripting language" on \
		ps_mem "lists processes by memory usage" on \
		rkhunter "rootkit, backdoor, sniffer and exploit scanner" off \
		rtorrent "ncurses BitTorrent client" off \
		tmux "terminal multiplexer" on \
		units "converts between different systems of units" on \
		varnish "high-performance web accelerator" off \
		vim "enhanced vi editor" off \
2>&1 1>&3 )

if [[ $halBox_packages == *"nodejs"* ]]; then
	halBox_NodeJS_modules=$( dialog \
		--no-cancel \
		--ok-label "Okay" \
		--separate-output \
		--title "halBox" \
		--checklist "Dave, select the Node.JS modules to install." 0 0 0 \
			calipso "content management system" off \
			connect "high performance middleware framework" off \
			express "Sinatra inspired web development framework" off \
			forever "ensure that a given node script runs continuously" off \
			hook.io "versatile distributed event emitter" off \
			jade "Jade template engine" off \
			log.io "real-time log monitoring in your browser" off \
			nib "Stylus mixins and utilities" off \
			pdfkit "PDF generation library" off \
			request "simplified HTTP request client" off \
			socket.io "WebSocket-like API" off \
			stylus "robust, expressive, and feature-rich CSS superset" off \
			underscore "functional programming helper library" off \
	2>&1 1>&3 )
fi

if [[ $halBox_packages == *"php"* ]]; then
	halBox_PHP_extensions=$( dialog \
		--no-cancel \
		--ok-label "Okay" \
		--separate-output \
		--title "halBox" \
		--checklist "Dave, select the PHP extensions to install." 0 0 0 \
			php-apc "Alternative PHP Cache" on \
			php5-curl "cURL" on \
			php5-enchant "Enchant Spelling Library" off \
			php5-ffmpeg "FFmpeg" off \
			php5-gd "GD" on \
			php5-gearman "Gearman" off \
			php5-geoip "MaxMind Geo IP" off \
			php5-gmp "GNU Multiple Precision" on \
			pecl_http "HTTP (Beta)" off \
			php5-imagick "ImageMagick" off \
			php5-imap "IMAP" on \
			php5-interbase "Firebird/InterBase Driver" off \
			php5-intl "Internationalization" on \
			php5-ldap "LDAP" off \
			php5-mcrypt "Mcrypt" on \
			php5-memcache "Memcache" off \
			php5-memcached "Memcached" off \
			php5-mhash "Mhash" off \
			pecl-mongo "MongoDB Driver" off \
			php5-mssql "MsSQL Driver" off \
			php5-mysql "MySQL Driver" on \
			php5-odbc "ODBC Driver" off \
			php-pear "PEAR & PECL" on \
			php5-pgsql "PostgreSQL Driver" off \
			php5-ps "PostScript" off \
			php5-pspell "GNU Aspell" off \
			php5-recode "GNU Recode" off \
			php5-redis "Redis" off \
			php5-snmp "SNMP" off \
			php5-sqlite "SQLite Driver" on \
			php5-ssh2 "SSH2" off \
			php5-suhosin "Suhosin Patch" off \
			php5-sybase "Sybase Driver" off \
			php5-tidy "Tidy" off \
			pecl-timezonedb "Olson timezone database" on \
			php5-tokyo-tyrant "Tokyo Tyrant" off \
			php5-xcache "XCache" off \
			php5-xdebug "Xdebug" off \
			php5-xhprof "XHProf" off \
			php5-xmlrpc "XML-RPC" off \
			php5-xsl "XSL" off \
	2>&1 1>&3 )
fi

if [[ $halBox_packages == *"mysql"* ]]; then
	halBox_MySQL_password=$( dialog \
		--insecure \
		--no-cancel \
		--ok-label "Okay" \
		--title "halBox" \
		--passwordbox "Dave, I also need a root password for MySQL." 0 80 \
	2>&1 1>&3 )
fi

exec 3>&-

clear && echo -e "\e[1;31mI'm completely operational, and all my circuits are functioning perfectly.\e[0m\n"

echo -e "\e[1;32mDave, I'm removing the bloatware.\e[0m" && for halBox_package in apache2 bind9 nscd portmap rsyslog samba sendmail; do
	if [[ -f /etc/init.d/$halBox_package ]]; then
		( service $halBox_package stop ) > /dev/null
	fi

	( apt-get -qq -y remove --purge "$halBox_package*" ) > /dev/null 2>&1
done

echo -e "\e[1;32mDave, I'm defaulting to the UTC timezone.\e[0m" && ( echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata ) > /dev/null 2>&1

if [[ ! $( type -P locale ) ]]; then
	echo -e "\e[1;32mDave, I'm installing 'locale'.\e[0m" && ( apt-get -qq -y install locale ) > /dev/null
fi

echo -e "\e[1;32mDave, I'm defaulting to the en_US.UTF-8 locale.\e[0m" && ( locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 ) > /dev/null

for halBox_package in $halBox_packages; do
	echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m"

	if [[ $halBox_package == "innotop" ]]; then
		echo -e "\e[1;32mDave, I'm skipping '$halBox_package' for now.\e[0m"
	elif [[ $halBox_package == "maldet" ]]; then
		( mkdir -p ~/halBox-master/_/ && wget -q http://www.rfxn.com/downloads/maldetect-current.tar.gz -O ~/halBox-master/_/maldet.tar.gz ) > /dev/null

		if [[ -f ~/halBox-master/_/maldet.tar.gz ]]; then
			( cd ~/halBox-master/_/ && tar -xzvf ./maldet.tar.gz && rm ./maldet.tar.gz && cd ./maldetect-*/ chmod +x ./install.sh && ./install.sh && cd ~ ) > /dev/null
		fi
	elif [[ $halBox_package == "mysql" ]]; then
		( cp -r ~/halBox-master/halBox/mysql/* / && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install mysql-server mysql-client mysqltuner ) > /dev/null
	elif [[ $halBox_package == "nodejs" ]]; then
		( apt-get -qq -y install nodejs npm ) > /dev/null
	elif [[ $halBox_package == "php" ]]; then
		( apt-get -qq -y install php5-cli php5-fpm ) > /dev/null
	elif [[ $halBox_package == "ps_mem" ]]; then
		( wget -q http://www.pixelbeat.org/scripts/ps_mem.py -O /usr/local/bin/ps_mem && chmod +x /usr/local/bin/ps_mem ) > /dev/null
	else
		( apt-get -qq -y install $halBox_package ) > /dev/null

		if [[ $halBox_package == "dropbear" ]]; then
			( apt-get -qq -y install xinetd ) > /dev/null
		fi
	fi
done

for halBox_package in clamav dash dropbear exim4 inetutils-syslogd iptables mysql nginx nodejs php; do
	if [[ $halBox_packages == *$halBox_package* ]]; then
		echo -e "\e[1;32mDave, I'm configuring '$halBox_package'.\e[0m"

		if [[ -d ~/halBox-master/halBox/$halBox_package/ ]]; then
			( cp -r ~/halBox-master/halBox/$halBox_package/* / ) > /dev/null
		fi

		if [[ $halBox_package == "clamav" ]]; then
			( freshclam ) > /dev/null

			if [[ -d /var/quarantine/ ]]; then
				chmod -R 0700 /var/quarantine/
			fi

			( ( crontab -l; echo "@daily freshclam && clamscan -ir /var/www/ --log=/var/log/clamscan.log --move=/var/quarantine/ --scan-mail=no" ) | crontab - ) > /dev/null 2>&1
		elif [[ $halBox_package == "dash" ]]; then
			( chsh -s /bin/dash root ) > /dev/null
		elif [[ $halBox_package == "dropbear" ]]; then
			( update-rc.d -f dropbear remove ) > /dev/null

			if [[ -f /etc/init.d/ssh ]]; then
				( touch /etc/ssh/sshd_not_to_be_run && service ssh stop && update-rc.d -f ssh remove ) > /dev/null 2>&1
			fi

			if [[ -f /etc/environment ]]; then
				( cat /etc/environment >> ~/.profile ) > /dev/null
			fi
		elif [[ $halBox_package == "exim4" ]]; then
			if [[ -f /etc/exim4/update-exim4.conf.conf ]]; then
				sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
			fi
		elif [[ $halBox_package == "inetutils-syslogd" ]]; then
			for halBox_path in "/var/log/*.*" "/var/log/debug" "/var/log/messages" "/var/log/syslog" "/var/log/fsck/" "/var/log/news/"; do
				( rm -rf $halBox_path ) > /dev/null
			done

			( service inetutils-syslogd stop && cp -r ~/halBox-master/halBox/inetutils-syslogd/* / ) > /dev/null
		elif [[ $halBox_package == "iptables" ]]; then
			( chmod +x /etc/network/if-pre-up.d/iptables && iptables-restore < /etc/iptables.rules ) > /dev/null
		elif [[ $halBox_package == "mysql" ]]; then
			if [[ ! $( type -P expect ) ]]; then
				( apt-get -qq -y install expect ) > /dev/null
			fi

			( chmod +x ~/halBox-master/bin/mysql.sh && expect -f ~/halBox-master/bin/mysql.sh $halBox_MySQL_password ) > /dev/null

			if [[ $? == 0 ]]; then
				if [[ ! -f ~/.my.cnf ]]; then
					( echo -e "[client]\nuser=root\npass=$halBox_MySQL_password\n" > ~/.my.cnf && chmod 0600 ~/.my.cnf )
				fi

				echo -e "\e[1;31mDave, your MySQL root password is now '$halBox_MySQL_password'.\e[0m"
			fi
		elif [[ $halBox_package == "nginx" ]]; then
			if [[ -f /etc/nginx/nginx.conf ]]; then
				sed -i "s/worker_processes [0-9]*;/worker_processes 2;/" /etc/nginx/nginx.conf
				sed -i "s/worker_connections [0-9]*;/worker_connections 1024;/" /etc/nginx/nginx.conf
			fi

			( chown -R www-data:www-data /var/www/ && make-ssl-cert generate-default-snakeoil --force-overwrite ) > /dev/null
		elif [[ $halBox_package == "nodejs" ]]; then
			for halBox_NodeJS_module in $halBox_NodeJS_modules; do
				echo -e "\e[1;32mDave, I'm installing '$halBox_NodeJS_package'.\e[0m" && ( npm install -gs $halBox_NodeJS_module ) > /dev/null
			done

			if [[ -d ~/tmp/ ]]; then
				( rm -rf ~/tmp/ ) > /dev/null
			fi
		elif [[ $halBox_package == "php" ]]; then
			echo -e "\e[1;32mDave, I'm downloading 'adminer'.\e[0m" && ( wget -q http://sourceforge.net/projects/adminer/files/latest/download -O /var/www/default/html/adminer/adminer.php ) > /dev/null

			if [[ ! -f /usr/local/bin/composer ]]; then
				echo -e "\e[1;32mDave, I'm downloading 'composer'.\e[0m" && ( wget -q http://getcomposer.org/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer ) > /dev/null
			fi

			for halBox_PHP_extension in $halBox_PHP_extensions; do
				echo -e "\e[1;32mDave, I'm installing '$halBox_PHP_extension'.\e[0m"

				if [[ $halBox_PHP_extension == "pecl"* ]]; then
					if [[ ! $( type -P pecl ) ]]; then
						( apt-get -qq -y install php-pear php5-dev ) > /dev/null
					fi

					if [[ $halBox_PHP_extension == "pecl_http" ]]; then
						( printf "no\n" | pecl install pecl_http ) > /dev/null
					else
						( pecl install ${halBox_PHP_extension:5} ) > /dev/null
					fi

					if [[ ! -f /etc/php5/conf.d/00-${halBox_PHP_extension:5}.ini ]]; then
						echo -e "[${halBox_PHP_extension:5}]\nextension=${halBox_PHP_extension:5}.so\n" > /etc/php5/conf.d/00-${halBox_PHP_extension:5}.ini
					fi
				elif [[ $halBox_PHP_extension == "php-pear" ]]; then
					( apt-get -qq -y install php-pear php5-dev ) > /dev/null
				else
					( apt-get -qq -y install $halBox_PHP_extension ) > /dev/null
				fi
			done

			for halBox_PHP_INI in /etc/php5/conf.d/{,20-}{interbase,mssql,mysql,odbc,pgsql,sqlite}*ini; do
				if [[ -f $halBox_PHP_INI ]]; then
					echo -e "\e[1;32mDave, I'm removing the non-PDO '$halBox_PHP_INI' file.\e[0m" && ( rm $halBox_PHP_INI ) > /dev/null
				fi
			done
		fi
	fi
done

for halBox_service in exim4 nginx mysql php5-fpm inetutils-syslogd xinetd; do
	if [[ -f /etc/init.d/$halBox_service ]]; then
		echo -e "\e[1;32mDave, I'm restarting the '$halBox_service' service.\e[0m" && ( service $halBox_service restart ) > /dev/null
	elif [[ $halBox_packages == *$halBox_service* ]]; then
		echo -e "\e[1;32mDave, I was unable to restart the '$halBox_service' service.\e[0m"
	fi
done

echo -e "\e[1;32mDave, I'm cleaning up the leftovers.\e[0m" && ( apt-get -qq -y autoremove && apt-get -qq -y autoclean ) > /dev/null

if [[ -f ~/halBox.tar.gz ]]; then
	( rm ~/halBox.tar.gz ) > /dev/null
fi

echo -e "\e[1;31mAffirmative, Dave. I read you.\e[0m" && exit 0
