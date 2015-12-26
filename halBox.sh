#!/usr/bin/env bash

# The MIT License
# http://creativecommons.org/licenses/MIT/
#
# halBox 0.51.2 (github.com/alixaxel/halBox/)
# Copyright (c) 2012 Alix Axel <alix.axel@gmail.com>

clear && echo -e "\e[1;31mhalBox 0.51.2\e[0m\n"

if [[ $(whoami) != "root" ]]; then
    echo -e "\e[1;31mDave, is that you?\e[0m" && exit 1
fi

if [[ ! -f /etc/debian_version ]]; then
    echo -e "\e[1;31mI think you know what the problem is just as well as I do.\e[0m" && exit 1
else
    halBox_Base=${0%/*}
    halBox_Bits=$([[ $(uname -m) == *"64" ]] && echo "64" || echo "32")
    halBox_CPU=$(grep "^physical id" /proc/cpuinfo | sort -u | wc -l)
    halBox_CPU_Cache=$(grep "^cache size" /proc/cpuinfo | sort -u | awk '{ print int($4 / 1024) }')
    halBox_CPU_Cores=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
    halBox_OS=$(lsb_release -si | awk '{ print tolower($0) }')
    halBox_OS_Codename=$(lsb_release -sc | awk '{ print tolower($0) }')
    halBox_RAM=$(grep "^MemTotal:" /proc/meminfo | awk '{ print int($2 / 1024) }')
fi

if [[ ! -d $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/ ]]; then
    echo -e "\e[1;31mI'm sorry, Dave. I'm afraid my circuits do not function properly on this system.\e[0m" && exit 1
elif [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename.sh ]]; then
    source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename.sh
fi

if [[ ! $(type -P dialog) ]]; then
    echo -e "\e[1;31mI'm sorry, Dave. I'm afraid I can't do that.\e[0m" && exit 1
else
    sleep 3
fi

exec 3>&1

halBox_packages=$(dialog \
    --cancel-label "Nevermind HAL" \
    --ok-label "Okay" \
    --separate-output \
    --title "halBox" \
    --checklist "Dave, select the packages to install." 0 0 0 \
            beanstalkd              "in-memory workqueue service"                       off \
            caddy                   "HTTP/2 web server with automatic HTTPS"            off \
            chkrootkit              "rootkit detector"                                  off \
            clamav                  "anti-virus utility"                                off \
            dash                    "lightweight POSIX-compliant shell"                 off \
            docker                  "lightweight software containers"                   off \
            exim4                   "mail transport agent"                              off \
            fail2ban                "log-based intrusion prevention tool"               off \
            git                     "distributed revision control system"               on \
            golang                  "Go programming language"                           off \
            imagemagick             "image manipulation programs"                       off \
            iptables                "tools for packet filtering and NAT"                on \
            jq                      "command-line JSON processor"                       off \
            julia                   "programming language for technical computing"      off \
            letsencrypt             "official Let's Encrypt client"                     on \
            libav-tools             "fast audio and video transcoder"                   off \
            maldet                  "linux malware scanner"                             off \
            mariadb                 "MariaDB 10 (drop-in replacement for MySQL)"        off \
            mc                      "powerful file manager"                             off \
            memcached               "high-performance memory object caching system"     off \
            mongodb                 "object/document-oriented database"                 off \
            mysql                   "MySQL database server and client"                  off \
            nginx                   "small, powerful & scalable web/proxy server"       on \
            nodejs                  "event-based server-side JavaScript engine"         off \
            pandoc                  "general markup converter"                          off \
            php5                    "server-side scripting language"                    off \
            php7                    "server-side scripting language"                    on \
            postgresql              "object-relational SQL database"                    off \
            ps_mem                  "lists processes by memory usage"                   on \
            r                       "language for statistical computing and graphics"   off \
            redis                   "persistent key-value database"                     off \
            rkhunter                "rootkit, backdoor, sniffer and exploit scanner"    off \
            rsync                   "file-copying tool & LIFO utilities"                on \
            rtorrent                "ncurses BitTorrent client"                         off \
            ruby                    "Ruby scripting language"                           off \
            scout_realtime          "modern top for the browser"                        off \
            sqlite                  "command line interface for SQLite 3"               on \
            supervisor              "process control system"                            off \
            tesseract-ocr           "open source OCR engine"                            off \
            vmtouch                 "file system cache diagnostics and control"         off \
            wkhtmltopdf             "HTML to PDF converter"                             off \
            yui-compressor          "JavaScript/CSS minifier & obfuscator"              off \
            zsh                     "shell with lots of features"                       off \
2>&1 1>&3)

if [[ $halBox_packages == *"php5"* ]]; then
    halBox_PHP5_packages=$(dialog \
        --no-cancel \
        --ok-label "Okay" \
        --separate-output \
        --title "halBox" \
        --checklist "Dave, select the PHP packages to install." 0 0 0 \
            php5-amqp               "AMQP PECL Module"                                  off \
            php5-apcu               "APC User Cache Module"                             off \
            php5-bitset             "Bitset PECL Module"                                off \
            php5-chdb               "Constant Hash Database PECL Module"                off \
            php5-composer           "Composer Module"                                   on \
            php5-curl               "cURL Module"                                       on \
            php5-discount           "Discount (Markdown) PECL Module"                   off \
            php5-doublemetaphone    "Double Metaphone PECL Module"                      off \
            php5-eio                "libeio PECL Module"                                off \
            php5-enchant            "Enchant Module"                                    off \
            php5-ev                 "livev PECL Module"                                 off \
            php5-fann               "Fast Artificial Neural Network PECL Module"        off \
            php5-gd                 "GD Module"                                         on \
            php5-gearman            "Gearman Module"                                    off \
            php5-gender             "Gender PECL Module"                                off \
            php5-geoip              "MaxMind GeoIP Module"                              off \
            php5-gmp                "GNU Multiple Precision Module"                     on \
            php5-gnupg              "GNU Privacy Guard Module"                          off \
            php5-http               "HTTP PECL Module"                                  off \
            php5-igbinary           "igbinary PECL Module"                              off \
            php5-imagick            "ImageMagick Module"                                on \
            php5-imap               "IMAP Module"                                       off \
            php5-inotify            "inotify PECL Module"                               off \
            php5-interbase          "Firebird / InterBase Module"                       off \
            php5-intl               "Internationalization Module"                       on \
            php5-jsmin              "JSMin PECL Module"                                 off \
            php5-json               "JSON Module"                                       on \
            php5-judy               "Judy Arrays PECL Module"                           off \
            php5-lasso              "Lasso Module"                                      off \
            php5-ldap               "LDAP Module"                                       off \
            php5-leveldb            "LevelDB Module"                                    off \
            php5-libevent           "libevent PECL Module"                              off \
            php5-librdf             "Redland RDF Module"                                off \
            php5-lzf                "lzf PECL Module"                                   off \
            php5-mailparse          "Mailparse PECL Module"                             off \
            php5-mapscript          "MapServer Module"                                  off \
            php5-mcrypt             "Mcrypt Module"                                     on \
            php5-memcache           "Memcache Module"                                   off \
            php5-memcached          "Memcached Module"                                  on \
            php5-mogilefs           "MogileFS PECL Module"                              off \
            php5-mongo              "MongoDB Module"                                    off \
            php5-msgpack            "MessagePack PECL Module"                           off \
            php5-mssql              "Sybase / MsSQL Module"                             off \
            php5-mysql              "MySQL Module"                                      on \
            php5-mysqlnd            "MySQL Native Module"                               off \
            php5-oauth              "OAuth 1.0 PECL Module"                             off \
            php5-odbc               "ODBC Module"                                       off \
            php5-opcache            "Zend OPcache PECL Module"                          on \
            php5-pgsql              "PostgreSQL Module"                                 on \
            php5-phalcon            "phalcon Module"                                    off \
            php5-phpunit            "PHPUnit Module"                                    on \
            php5-pinba              "Pinba Module"                                      off \
            php5-protocolbuffers    "Protocol Buffers PECL Module"                      off \
            php5-ps                 "PostScript Module"                                 off \
            php5-pspell             "GNU Aspell Module"                                 off \
            php5-quickhash          "QuickHash PECL Module"                             off \
            php5-radius             "Radius PECL Module"                                off \
            php5-rar                "RAR PECL Module"                                   off \
            php5-readline           "GNU Readline Module"                               off \
            php5-recode             "GNU Recode Module"                                 off \
            php5-redis              "Redis Module"                                      off \
            php5-scream             "Scream PECL Module"                                off \
            php5-scrypt             "Scrypt PECL Module"                                off \
            php5-solr               "Apache Solr PECL Module"                           off \
            php5-sphinx             "Sphinx PECL Module"                                off \
            php5-spidermonkey       "Spidermonkey PECL Module"                          off \
            php5-sqlite             "SQLite Module"                                     on \
            php5-ssdeep             "ssdeep PECL Module"                                off \
            php5-ssh2               "SSH2 PECL Module"                                  off \
            php5-stats              "Statistics PECL Module"                            off \
            php5-stem               "Stem PECL Module"                                  off \
            php5-stomp              "STOMP Module"                                      off \
            php5-sundown            "Sundown (Markdown) PECL Module"                    off \
            php5-svm                "Support Vector Machine PECL Module"                off \
            php5-svn                "SVN Module"                                        off \
            php5-swoole             "Swoole PECL Module"                                off \
            php5-tidy               "Tidy Module"                                       off \
            php5-timezonedb         "Olson Timezone Database PECL Module"               on \
            php5-tokyo_tyrant       "Tokyo Tyrant PECL Module"                          off \
            php5-uuid               "uuid PECL Module"                                  off \
            php5-varnish            "Varnish Cache PECL Module"                         off \
            php5-xcache             "XCache Opcode Cacher Module"                       off \
            php5-xdebug             "Xdebug Module"                                     off \
            php5-xhprof             "XHProf Module"                                     off \
            php5-xmlrpc             "XML-RPC Module"                                    off \
            php5-xsl                "XSL Module"                                        off \
            php5-yaf                "yaf PECL Module"                                   off \
            php5-yaml               "YAML 1.1 PECL Module"                              off \
            php5-yar                "Yar PECL Module"                                   off \
    2>&1 1>&3)
fi

if [[ $halBox_packages == *"php7"* ]]; then
    halBox_PHP7_packages=$(dialog \
        --no-cancel \
        --ok-label "Okay" \
        --separate-output \
        --title "halBox" \
        --checklist "Dave, select the PHP packages to install." 0 0 0 \
            php7-composer           "Composer Module"                                   on \
            php7-curl               "cURL Module"                                       on \
            php7-gd                 "GD Module"                                         on \
            php7-imap               "IMAP Module"                                       off \
            php7-interbase          "Firebird / InterBase Module"                       off \
            php7-intl               "Internationalization Module"                       on \
            php7-json               "JSON Module"                                       on \
            php7-ldap               "LDAP Module"                                       off \
            php7-memcached          "Memcached Module"                                  on \
            php7-mysql              "MySQL Module"                                      on \
            php7-odbc               "ODBC Module"                                       off \
            php7-opcache            "Zend OPcache Module"                               on \
            php7-pgsql              "PostgreSQL Module"                                 on \
            php7-phpunit            "PHPUnit Module"                                    on \
            php7-pspell             "GNU Aspell Module"                                 off \
            php7-readline           "GNU Readline Module"                               off \
            php7-recode             "GNU Recode Module"                                 off \
            php7-redis              "Redis Module"                                      off \
            php7-sqlite             "SQLite Module"                                     on \
            php7-tidy               "Tidy Module"                                       off \
            php7-timezonedb         "Olson Timezone Database PECL Module"               on \
            php7-xmlrpc             "XML-RPC Module"                                    off \
    2>&1 1>&3)
fi

if [[ ($halBox_packages == *"mariadb"*) || ($halBox_packages == *"mysql"*) ]]; then
    halBox_MySQL_password=$(dialog \
        --insecure \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --passwordbox "Dave, I also need a root password for MySQL." 0 80 \
    2>&1 1>&3)

    halBox_MySQL_networking=$(dialog \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --radiolist "Dave, do you want to allow remote access to MySQL?" 0 80 0 \
            0 "No" on \
            1 "Yes" off \
    2>&1 1>&3)
fi

if [[ $halBox_packages == *"postgresql"* ]]; then
    halBox_PostgreSQL_password=$(dialog \
        --insecure \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --passwordbox "Dave, I also need a root password for PostgreSQL." 0 80 \
    2>&1 1>&3)

    halBox_PostgreSQL_networking=$(dialog \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --radiolist "Dave, do you want to allow remote access to PostgreSQL?" 0 80 0 \
            0 "No" on \
            1 "Yes" off \
    2>&1 1>&3)
fi

if [[ $halBox_packages == *"letsencrypt"* ]]; then
    halBox_LetsEncrypt_email=$(dialog \
        --no-cancel \
        --ok-label "Okay" \
        --title "halBox" \
        --inputbox "Dave, I also need an email for Let's Encrypt." 0 80 \
    2>&1 1>&3)
fi

exec 3>&-

clear && echo -e "\e[1;31mI'm completely operational, and all my circuits are functioning perfectly.\e[0m\n"

for halBox_package in $halBox_packages; do
    echo -e "\e[1;32mDave, I'm installing '$halBox_package'.\e[0m"

    if [[ -f $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_package.sh ]]; then
        source $halBox_Base/packages/$halBox_OS/$halBox_OS_Codename/$halBox_package.sh
    else
        apt-get -qq install $halBox_package > /dev/null

        if [[ $? != 0 ]]; then
            echo -e "\e[1;31mSomething went wrong installing '$halBox_package'.\e[0m"
        fi
    fi
done

echo -e "\e[1;32mDave, I'm cleaning up the leftovers.\e[0m" && apt-get -qq autoclean > /dev/null && apt-get -qq autoremove > /dev/null

if [[ -f ~/halBox.tar.gz ]]; then
    rm ~/halBox.tar.gz
fi

echo -e "\e[1;31mAffirmative, Dave. I read you.\e[0m" && exit 0
