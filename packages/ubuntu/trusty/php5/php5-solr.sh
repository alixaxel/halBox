#!/usr/bin/env bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev php5-curl libxml2-dev libcurl4-openssl-dev > /dev/null

if [[ ! -f /etc/php5/mods-available/solr.ini ]]; then
    echo "" > /etc/php5/mods-available/solr.ini

    pear config-set php_ini /etc/php5/mods-available/solr.ini > /dev/null && yes "" | pecl -q install -f solr > /dev/null

    if [[ $(cat /etc/php5/mods-available/solr.ini | wc -c) -le 1 ]]; then
        echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP5_package'.\e[0m" && rm -f /etc/php5/mods-available/solr.ini
    else
        cp -r $halBox_Base/overlay/php5-solr/. / && php5enmod solr
    fi

    pear config-set php_ini "" > /dev/null
fi
