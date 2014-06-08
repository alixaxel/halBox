#!/bin/bash

apt-get -qq install php-pear php5-dev re2c libpcre3-dev > /dev/null

if [[ ! $(type -P git) ]]; then
	apt-get -qq install git > /dev/null
fi

git clone -q git://github.com/lstrojny/php-cld.git /tmp/php-cld/

if [[ $? == 0 ]]; then
	cd /tmp/php-cld/ && git reset --hard -q fd5aa5721b01bfe547ff6674fa0daa9c3b791ca3

	if [[ $? == 0 ]]; then
		cd /tmp/php-cld/vendor/libcld/ && ./build.sh > /dev/null

		if [[ $? == 0 ]]; then
			cd /tmp/php-cld/ && phpize > /dev/null && ./configure --with-libcld-dir=/tmp/php-cld/vendor/libcld/ > /dev/null && make > /dev/null && make install > /dev/null

			if [[ $? == 0 ]]; then
				echo "extension=cld.so" > /etc/php5/mods-available/cld.ini
			fi
		fi
	fi
fi

if [[ $(cat /etc/php5/mods-available/cld.ini | wc -c) -le 1 ]]; then
	echo -e "\e[1;31mSomething went wrong installing '$halBox_PHP_package'.\e[0m" && rm -f /etc/php5/mods-available/cld.ini
fi

cd ~ && rm -rf /tmp/php-cld/
