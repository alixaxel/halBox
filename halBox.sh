#!/bin/bash

# The MIT License
# http://creativecommons.org/licenses/MIT/
#
# halBox 0.35.1 (github.com/alixaxel/halBox)
# Copyright (c) 2012 Alix Axel <alix.axel@gmail.com>

clear && echo -e "\e[1;31mhalBox 0.35.1\e[0m\n"

if [[ $( whoami ) != "root" ]]; then
    echo -e "\e[1;31mDave, is that you?\e[0m" && exit 1
fi

if [[ ! -f /etc/debian_version ]]; then
    echo -e "\e[1;31mI think you know what the problem is just as well as I do.\e[0m" && exit 1
else
    halBox_Bits=32
    halBox_CPU=$( grep "^physical id" /proc/cpuinfo | sort -u | wc -l )
    halBox_CPU_Cache=$( grep "^cache size" /proc/cpuinfo | sort -u | awk '{ print int($4 / 1024) }' )
    halBox_CPU_Cores=$( grep "^core id" /proc/cpuinfo | sort -u | wc -l )
    halBox_OS=$( lsb_release -si | awk '{ print tolower($0) }' )
    halBox_OS_Codename=$( lsb_release -sc | awk '{ print tolower($0) }' )
    halBox_RAM=$( grep "^MemTotal:" /proc/meminfo | awk '{ print int($2 / 1024) }' )

    if [[ `uname -m` == *"64" ]]; then
        halBox_Bits=64
    fi
fi

if [[ $halBox_OS == "debian" ]]; then
    if [[ ! -f /etc/apt/sources.list.d/dotdeb.list ]]; then
        echo -e "\e[1;32mDave, I'm adding the DotDeb repository.\e[0m"

        for halBox_branch in $halBox_OS_Codename "$halBox_OS_Codename-php54"; do
            echo -e "deb http://packages.dotdeb.org/ $halBox_branch all\n" >> /etc/apt/sources.list.d/dotdeb.list
            echo -e "deb-src http://packages.dotdeb.org/ $halBox_branch all\n" >> /etc/apt/sources.list.d/dotdeb.list
        done
    fi

    ( wget -q http://www.dotdeb.org/dotdeb.gpg -O - | apt-key add - ) > /dev/null 2>&1
elif [[ $halBox_OS == "ubuntu" ]]; then
    if [[ ! $( type -P add-apt-repository ) ]]; then
        echo -e "\e[1;32mDave, hold on...\e[0m" && ( apt-get -qq -y update && apt-get -qq -y install python-software-properties ) > /dev/null 2>&1
    fi

    for halBox_PPA in chris-lea/node.js ondrej/php5; do
        echo -e "\e[1;32mDave, I'm adding the $halBox_PPA PPA.\e[0m" && ( add-apt-repository -y ppa:$halBox_PPA ) > /dev/null 2>&1
    done
fi

echo -e "\e[1;32mDave, I'm updating the repositories...\e[0m" && ( apt-get -qq -y update && apt-get -qq -y upgrade && apt-get -qq -y install whiptail locales ) > /dev/null 2>&1

if [[ $( type -P locale-gen ) && $( type -P update-locale ) ]]; then
    echo -e "\e[1;32mDave, I'm defaulting to the 'en_US.UTF-8' locale.\e[0m" && ( locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 ) > /dev/null
fi

for halBox_package in ack-grep bc bcrypt build-essential cloc curl dialog dstat host htop iftop ioping iotop libnss-myhostname nano ncdu scrypt sloccount ssdeep strace units unzip virt-what zip; do
    echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m" && ( apt-get -qq -y install $halBox_package ) > /dev/null
done

if [[ $( virt-what ) == "virtualbox" ]]; then
    echo -e "\e[1;32mDave, I'm installing VirtualBox Guest Additions...\e[0m"

    if [[ $halBox_OS == "debian" ]]; then
        ( DEBIAN_FRONTEND=noninteractive apt-get -qq -y install virtualbox-ose-guest-dkms ) > /dev/null
    elif [[ $halBox_OS == "ubuntu" ]]; then
        ( DEBIAN_FRONTEND=noninteractive apt-get -qq -y install virtualbox-guest-dkms ) > /dev/null
    fi
fi

echo -e "\e[1;32mDave, I'm removing the bloatware.\e[0m" && for halBox_package in apache2 bind9 nscd php portmap rsyslog samba sendmail; do
    if [[ $halBox_package == "php" && -d /etc/php5/fpm/ ]]; then
        continue
    fi

    if [[ -f /etc/init.d/$halBox_package ]]; then
        ( service $halBox_package stop ) > /dev/null 2>&1
    fi

    ( apt-get -qq -y remove --purge "^$halBox_package*" ) > /dev/null 2>&1
done

echo -e "\e[1;32mDave, I'm defaulting to the UTC timezone.\e[0m" && ( echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata ) > /dev/null 2>&1

if [[ ! $( type -P dialog ) ]]; then
    echo -e "\e[1;31mI'm sorry, Dave. I'm afraid I can't do that.\e[0m" && exit 1
else
    sleep 3
fi

exec 3>&1

halBox_packages=$( dialog \
    --cancel-label "Nevermind HAL" \
    --ok-label "Okay" \
    --separate-output \
    --title "halBox" \
    --checklist "Dave, select the packages to install." 0 0 0 \
            chkrootkit          "rootkit detector"                                  off \
            clamav              "anti-virus utility for Unix"                       off \
            dash                "POSIX-compliant shell"                             off \
            dropbear            "lightweight SSH2 server and client"                off \
            exim4               "mail transport agent"                              on \
            git-core            "distributed revision control system"               on \
            hub                 "git + hub = github"                                on \
            inetutils-syslogd   "system logging daemon"                             on \
            iptables            "tools for packet filtering and NAT"                on \
            maldet              "linux malware scanner"                             off \
            mc                  "powerful file manager"                             off \
            memcached           "high-performance memory object caching system"     off \
            meteor              "JavaScript platform for building HTML5 websites"   off \
            mongodb             "object/document-oriented database"                 off \
            mysql               "MySQL database server and client"                  on \
            nginx-light         "small, powerful & scalable web/proxy server"       on \
            nodejs              "event-based server-side JavaScript engine"         off \
            ntp                 "network time protocol deamon"                      off \
            php                 "server-side, HTML-embedded scripting language"     on \
            ps_mem              "lists processes by memory usage"                   on \
            rkhunter            "rootkit, backdoor, sniffer and exploit scanner"    off \
            rsync               "file-copying tool & LIFO utilities"                on \
            rtorrent            "ncurses BitTorrent client"                         off \
            tesseract-ocr       "open source OCR engine"                            off \
            tmux                "terminal multiplexer"                              on \
            trimage             "lossless image optimizer"                          on \
            vim                 "enhanced vi editor"                                off \
            wkhtmltopdf         "utility to convert HTML to PDF"                    off \
            yui-compressor      "JavaScript/CSS minifier & obfuscator"              on \
2>&1 1>&3 )

if [[ $halBox_packages == *"php"* ]]; then
    halBox_PHP_extensions=$( dialog \
        --no-cancel \
        --ok-label "Okay" \
        --separate-output \
        --title "halBox" \
        --checklist "Dave, select the PHP extensions to install." 0 0 0 \
            php5-apc            "Alternative PHP Cache"                             on \
            php5-curl           "cURL"                                              on \
            php5-enchant        "Enchant Spelling Library"                          off \
            php5-ffmpeg         "FFmpeg"                                            off \
            php5-gd             "GD"                                                on \
            php5-gearman        "Gearman"                                           off \
            php5-geoip          "MaxMind Geo IP"                                    off \
            php5-gmp            "GNU Multiple Precision"                            on \
            pecl_http           "HTTP (Beta)"                                       off \
            php5-imagick        "ImageMagick"                                       on \
            php5-imap           "IMAP"                                              on \
            php5-interbase      "Firebird/InterBase Driver"                         off \
            php5-intl           "Internationalization"                              on \
            php5-ldap           "LDAP"                                              off \
            php5-mcrypt         "Mcrypt"                                            on \
            php5-memcache       "Memcache"                                          off \
            php5-memcached      "Memcached"                                         off \
            php5-mhash          "Mhash"                                             off \
            pecl-mongo          "MongoDB Driver"                                    off \
            php5-mssql          "MsSQL Driver"                                      off \
            php5-mysql          "MySQL Driver"                                      on \
            php5-odbc           "ODBC Driver"                                       off \
            php-pear            "PEAR & PECL"                                       on \
            php5-pgsql          "PostgreSQL Driver"                                 off \
            php5-ps             "PostScript"                                        off \
            php5-pspell         "GNU Aspell"                                        off \
            php5-recode         "GNU Recode"                                        off \
            php5-redis          "Redis"                                             off \
            php5-snmp           "SNMP"                                              off \
            php5-sqlite         "SQLite Driver"                                     on \
            pecl-ssdeep         "Fuzzy Hashing"                                     off \
            php5-ssh2           "SSH2"                                              off \
            pecl-stats          "Statistical Library"                               off \
            php5-suhosin        "Suhosin Patch"                                     off \
            php5-sybase         "Sybase Driver"                                     off \
            php5-tidy           "Tidy"                                              on \
            pecl-timezonedb     "Olson timezone database"                           on \
            php5-xdebug         "Xdebug"                                            off \
            pecl-xhprof-beta    "XHProf"                                            on \
            php5-xmlrpc         "XML-RPC"                                           off \
            php5-xsl            "XSL"                                               off \
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

    halBox_MySQL_remote=$( dialog \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --radiolist "Dave, do you want to allow remote MySQL access?" 0 80 0 \
            0 "No" on \
            1 "Yes" off \
    2>&1 1>&3 )
fi

exec 3>&-

clear && echo -e "\e[1;31mI'm completely operational, and all my circuits are functioning perfectly.\e[0m\n"

for halBox_package in $halBox_packages; do
    echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m"

    if [[ $halBox_package == "hub" ]]; then
        for halBox_hub_prerequisite in ruby git-core; do
            ( apt-get -qq -y install $halBox_hub_prerequisite ) > /dev/null
        done
        
        ( wget -q http://hub.github.com/standalone -O /usr/local/bin/hub && chmod +x /usr/local/bin/hub ) > /dev/null
    elif [[ $halBox_package == "maldet" ]]; then
        ( wget -q http://www.rfxn.com/downloads/maldetect-current.tar.gz -O ~/halBox-master/_/maldet.tar.gz ) > /dev/null

        if [[ -f ~/halBox-master/_/maldet.tar.gz ]]; then
            ( cd ~/halBox-master/_/ && tar -xzvf ./maldet.tar.gz && cd ./maldetect-*/ && chmod +x ./install.sh && ./install.sh && cd ~ ) > /dev/null
        fi
    elif [[ $halBox_package == "meteor" ]]; then
        ( curl -s https://install.meteor.com/ | /bin/sh ) > /dev/null 2>&1
    elif [[ $halBox_package == "mysql" ]]; then
        ( cp -r ~/halBox-master/halBox/mysql/* / && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install mysql-server mysql-client ) > /dev/null
    elif [[ $halBox_package == "nodejs" ]]; then
        if [[ $halBox_OS == "debian" ]]; then
            ( wget -q http://nodejs.org/dist/node-latest.tar.gz -O ~/halBox-master/_/node.tar.gz ) > /dev/null

            if [[ -f ~/halBox-master/_/node.tar.gz ]]; then
                ( cd ~/halBox-master/_/ && tar -xzvf ./node.tar.gz && cd ./node-*/ && ./configure && make install && cd ~ ) > /dev/null 2>&1
            fi
        elif [[ $halBox_OS == "ubuntu" ]]; then
            ( apt-get -qq -y install nodejs npm ) > /dev/null
        fi
    elif [[ $halBox_package == "php" ]]; then
        ( apt-get -qq -y install php5-cli php5-fpm ) > /dev/null
    elif [[ $halBox_package == "ps_mem" ]]; then
        ( wget -q http://www.pixelbeat.org/scripts/ps_mem.py -O /usr/local/bin/ps_mem && chmod +x /usr/local/bin/ps_mem ) > /dev/null
    elif [[ $halBox_package == "trimage" ]]; then
        ( apt-get -qq -y install trimage ) > /dev/null 2>&1
    else
        ( apt-get -qq -y install $halBox_package ) > /dev/null

        if [[ $halBox_package == "dropbear" ]]; then
            ( apt-get -qq -y install xinetd ) > /dev/null
        fi
    fi
done

for halBox_package in clamav dash dropbear exim4 inetutils-syslogd iptables mysql nginx-light nodejs php rsync; do
    if [[ $halBox_packages == *$halBox_package* ]]; then
        echo -e "\e[1;32mDave, I'm configuring '$halBox_package'.\e[0m"

        if [[ -d ~/halBox-master/halBox/$halBox_package/ ]]; then
            ( cp -r ~/halBox-master/halBox/$halBox_package/* / ) > /dev/null
        fi

        if [[ $halBox_package == "clamav" ]]; then
            ( freshclam ) > /dev/null

            if [[ -d /var/quarantine/ ]]; then
                ( chmod -R 0700 /var/quarantine/ )
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
                ( sed -i "s~dc_eximconfig_configtype='local'~dc_eximconfig_configtype='internet'~" /etc/exim4/update-exim4.conf.conf )
            fi
        elif [[ $halBox_package == "inetutils-syslogd" ]]; then
            for halBox_path in /var/log/{"*.*",debug,messages,syslog,fsck/,news/}; do
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
                if [[ -f ~/.my.cnf ]]; then
                    ( sed -i -r "s~^pass([[:blank:]]*)=$;~pass\1= $halBox_MySQL_password;~" ~/.my.cnf && chmod 0600 ~/.my.cnf )
                fi

                echo -e "\e[1;31mDave, your MySQL root password is now '$halBox_MySQL_password'.\e[0m"

                if [[ $halBox_MySQL_remote == "1" ]]; then
                    ( mysql -uroot -p$( printf "%q" "$halBox_MySQL_password" ) -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$( printf "%q" "$halBox_MySQL_password" )' WITH GRANT OPTION; FLUSH PRIVILEGES;" ) > /dev/null 2>&1

                    if [[ $? == 0 ]]; then
                        ( sed -i "s~skip-networking~#skip-networking~" /etc/mysql/conf.d/halBox.cnf && echo -e "\e[1;31mDave, remote MySQL access is now enabled.\e[0m" )
                    fi
                fi
            fi

            for halBox_MySQL_package in innotop mysqltuner tuning-primer; do
                echo -e "\e[1;32mDave, I'm also downloading '$halBox_MySQL_package'.\e[0m"

                if [[ $halBox_MySQL_package == "innotop" ]]; then
                    ( wget -q http://innotop.googlecode.com/files/innotop-1.9.0.tar.gz -O ~/halBox-master/_/innotop.tar.gz ) > /dev/null

                    if [[ -f ~/halBox-master/_/innotop.tar.gz ]]; then
                        for halBox_innotop_prerequisite in libterm-readkey-perl libdbi-perl libdbd-mysql; do
                            ( apt-get -qq -y install $halBox_innotop_prerequisite ) > /dev/null
                        done

                        ( cd ~/halBox-master/_/ && tar -xzvf ./innotop.tar.gz && cd ./innotop-*/ && perl ./Makefile.PL && make install && cd ~ ) > /dev/null
                    fi
                elif [[ $halBox_MySQL_package == "mysqltuner" ]]; then
                    ( wget -q https://raw.github.com/rackerhacker/MySQLTuner-perl/master/mysqltuner.pl -O /usr/local/bin/mysqltuner ) > /dev/null
                elif [[ $halBox_MySQL_package == "tuning-primer" ]]; then
                    ( wget -q https://launchpad.net/mysql-tuning-primer/trunk/1.6-r1/+download/tuning-primer.sh -O /usr/local/bin/tuning-primer ) > /dev/null
                fi

                if [[ -f /usr/local/bin/$halBox_MySQL_package ]]; then
                    ( chmod +x /usr/local/bin/$halBox_MySQL_package )
                fi
            done
        elif [[ $halBox_package == "nginx-light" ]]; then
            if [[ -f /etc/nginx/nginx.conf ]]; then
                if [[ $halBox_CPU_Cores -ge 2 ]]; then
                    ( sed -i -r "s~worker_processes([[:blank:]]*)[0-9]*;~worker_processes\1$halBox_CPU_Cores;~" /etc/nginx/nginx.conf )
                fi

                ( make-ssl-cert generate-default-snakeoil --force-overwrite ) > /dev/null
            fi

            for halBox_nginx_package in apache2-utils httperf siege; do
                echo -e "\e[1;32mDave, I'm also installing '$halBox_nginx_package'.\e[0m" && ( apt-get -qq -y install $halBox_nginx_package ) > /dev/null
            done

            ( mkdir -p /var/{cache/nginx/,www/} && chown -R www-data:www-data /var/{cache/nginx/,www/} && chmod +x /usr/sbin/{n1dissite,n1ensite} )
        elif [[ $halBox_package == "php" ]]; then
            if [[ $halBox_packages == *"nginx-light"* ]]; then
                echo -e "\e[1;32mDave, I'm also downloading 'adminer'.\e[0m" && ( wget -q http://sourceforge.net/projects/adminer/files/latest/download -O /var/www/default/htdocs/adminer/adminer.php ) > /dev/null
            fi

            if [[ ! -f /usr/local/bin/composer ]]; then
                echo -e "\e[1;32mDave, I'm also downloading 'composer'.\e[0m" && ( wget -q http://getcomposer.org/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer ) > /dev/null
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
                        if [[ $halBox_PHP_extension == "pecl-ssdeep" ]]; then
                            ( apt-get -qq -y install libfuzzy-dev ) > /dev/null
                        fi

                        ( pecl install ${halBox_PHP_extension:5} ) > /dev/null

                        if [[ $halBox_PHP_extension == *"-beta" ]]; then
                            halBox_PHP_extension=${halBox_PHP_extension:0:-5}
                        fi
                    fi

                    if [[ ! -f /etc/php5/fpm/conf.d/00-${halBox_PHP_extension:5}.ini ]]; then
                        echo -e "[${halBox_PHP_extension:5}]\nextension=${halBox_PHP_extension:5}.so\n" > /etc/php5/fpm/conf.d/00-${halBox_PHP_extension:5}.ini
                    fi
                elif [[ $halBox_PHP_extension == "php-pear" ]]; then
                    ( apt-get -qq -y install php-pear php5-dev ) > /dev/null
                elif [[ $halBox_PHP_extension == "php5-apc" && $halBox_OS == "ubuntu" ]]; then
                    ( apt-get -qq -y install php-apc ) > /dev/null
                else
                    ( apt-get -qq -y install $halBox_PHP_extension ) > /dev/null
                fi
            done

            for halBox_PHP_INI in /etc/php5/fpm/conf.d/{,20-}{interbase,mssql,mysql,odbc,pgsql,sqlite}*ini; do
                if [[ -f $halBox_PHP_INI ]]; then
                    echo -e "\e[1;32mDave, I'm removing the non-PDO '$halBox_PHP_INI' file.\e[0m" && ( rm $halBox_PHP_INI ) > /dev/null
                fi
            done
        elif [[ $halBox_package == "rsync" ]]; then
            ( chmod +x /usr/sbin/{rsync_cp,rsync_mv,rsync_rm} )
        fi
    fi
done

if [[ -d /var/www/ && -n $SUDO_USER ]]; then
    ( usermod -a -G www-data "$SUDO_USER" && chgrp -R www-data /var/www/ && chmod -R g+rsw /var/www/ ) > /dev/null
fi

for halBox_service in exim4 nginx mysql php5-fpm inetutils-syslogd xinetd; do
    if [[ -f /etc/init.d/$halBox_service ]]; then
        echo -e "\e[1;32mDave, I'm restarting the '$halBox_service' service.\e[0m" && ( service $halBox_service restart ) > /dev/null
    fi
done

echo -e "\e[1;32mDave, I'm cleaning up the leftovers.\e[0m" && ( apt-get -qq -y autoremove && apt-get -qq -y autoclean ) > /dev/null

if [[ -f ~/halBox.tar.gz ]]; then
    ( rm ~/halBox.tar.gz ) > /dev/null
fi

echo -e "\e[1;31mAffirmative, Dave. I read you.\e[0m" && exit 0
