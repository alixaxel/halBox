halBox
======

Bash script with a bit of unicornian magic dust to set up and tweak your Ubuntu servers.

***Nota bene:*** halBox ships with the harmless [EICAR test virus file](http://en.wikipedia.org/wiki/EICAR_test_file) to assess ClamAV.

As of version 0.40.0, halBox compatibility is reduced to Ubuntu 14.04 LTS only.

Setup
=====

As *root*, copy+paste the following on your command-line:

```shell
cd ~ && \
wget -q https://github.com/alixaxel/halBox/archive/master.tar.gz -O ~/halBox.tar.gz && \
tar -xzvf ~/halBox.tar.gz && \
chmod +x ~/halBox-master/halBox.sh && \
~/halBox-master/halBox.sh
```

A default install should take less than 5 minutes to complete.

Memory Usage
============

halBox is VPS-oriented, it has been crafted to consume as little memory as possible.

Here's what a default install looks like after a fresh *reboot* (under Ubuntu 14.04 LTS):

    root@trusty:~# ps_mem
      Private + Shared    = RAM         Program

     96.0 KiB +  35.0 KiB = 131.0 KiB   lockfile-touch
    104.0 KiB +  35.0 KiB = 139.0 KiB   lockfile-create
    188.0 KiB +  25.0 KiB = 213.0 KiB   ureadahead
    184.0 KiB +  31.5 KiB = 215.5 KiB   atd
    172.0 KiB +  65.5 KiB = 237.5 KiB   acpid
    192.0 KiB +  50.5 KiB = 242.5 KiB   ondemand
    180.0 KiB +  84.0 KiB = 264.0 KiB   sleep (2)
    284.0 KiB + 100.0 KiB = 384.0 KiB   cron
    288.0 KiB + 142.5 KiB = 430.5 KiB   ping (2)
    380.0 KiB +  60.5 KiB = 440.5 KiB   upstart-socket-bridge
    364.0 KiB +  97.0 KiB = 461.0 KiB   upstart-udev-bridge
    412.0 KiB +  60.0 KiB = 472.0 KiB   upstart-file-bridge
    568.0 KiB + 179.5 KiB = 747.5 KiB   systemd-logind
    728.0 KiB +  66.0 KiB = 794.0 KiB   dbus-daemon
    588.0 KiB + 230.5 KiB = 818.5 KiB   ntpdate (3)
    860.0 KiB +  92.5 KiB = 952.5 KiB   systemd-udevd
      1.0 MiB +  79.0 KiB =   1.1 MiB   rsyslogd
    952.0 KiB + 339.0 KiB =   1.3 MiB   getty (6)
      1.6 MiB + 146.5 KiB =   1.7 MiB   init
      2.6 MiB + 110.0 KiB =   2.7 MiB   bash
      2.0 MiB + 834.0 KiB =   2.8 MiB   nginx (3)
      2.1 MiB +   1.4 MiB =   3.5 MiB   sshd (2)
      9.3 MiB + 324.5 KiB =   9.6 MiB   mysqld
     12.1 MiB +   7.4 MiB =  19.5 MiB   php5-fpm (3)
    ---------------------------------
                             48.9 MiB
    =================================

Of course, some features and configurations had to be sacrificed, most notably:

* InnoDB engine is disabled if your server has less than 512MB of RAM
* MyISAM [`key_buffer_size` directive](http://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_key_buffer_size) is set to 8MB
* *non*-PDO database drivers are disabled by default (this includes `mysql` and `mysqli`)

As of version 0.31.0, halBox also ships with custom rsync LIFO directory utilities:

* [`rsync_cp`](https://github.com/alixaxel/halBox/blob/master/overlay/rsync/usr/local/bin/rsync_cp)
* [`rsync_mv`](https://github.com/alixaxel/halBox/blob/master/overlay/rsync/usr/local/bin/rsync_mv)
* [`rsync_rm`](https://github.com/alixaxel/halBox/blob/master/overlay/rsync/usr/local/bin/rsync_rm)

As of version 0.40.0, halBox comes with three helper scripts for nginx:

* [`ngxensite`](https://github.com/alixaxel/halBox/blob/master/overlay/nginx/usr/local/sbin/ngxensite) (mimics Apache [`a2ensite`](http://manpages.ubuntu.com/manpages/precise/man8/a2ensite.8.html))
* [`ngxdissite`](https://github.com/alixaxel/halBox/blob/master/overlay/nginx/usr/local/sbin/ngxdissite) (mimics Apache [`a2dissite`](http://manpages.ubuntu.com/manpages/precise/man8/a2dissite.8.html))
* [`ngxgzip`](https://github.com/alixaxel/halBox/blob/master/overlay/nginx/usr/local/sbin/ngxgzip) (optimal asset pre-compressor for [`gzip_static`](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html))

As of version 0.50.0, halBox ships with [Let's Encrypt](https://letsencrypt.org/) and:

* [`ngxsite`](https://github.com/alixaxel/halBox/blob/master/overlay/nginx/usr/local/sbin/ngxsite) (deploys a new nginx virtual host with SSL and *non-www to www* redirection)

Screens *(Ubuntu)*
==================

*These may not (and probably do not) reflect the current version of the script / packages.*

![Demo](http://i.imgur.com/hzYf9DL.gif "Demo")

Software
========

```
ack-grep
apache2-utils
bc
bcrypt
beanstalkd
build-essential
caddy
chkrootkit
clamav
cloc
curl
dash
dialog
docker
dstat
exim4
git
golang
host
htop
httperf
hub
iftop
imagemagick
innotop
ioping
iotop
iptables
jpegoptim
jq
julia
lets-encrypt
letsencrypt
libav-tools
maldet
mariadb
mc
memcached
mongodb
mycli
mysql
mysqltuner
nano
ncdu
nginx
ngxdissite
ngxensite
ngxgzip
ngxtop
nodejs
ntp
optipng
pandoc
pgcli
pgloader
pgtop
pgtune
php5
php5-adminer
php5-amqp
php5-apcu
php5-bitset
php5-chdb
php5-composer
php5-curl
php5-discount
php5-doublemetaphone
php5-eio
php5-enchant
php5-ev
php5-fann
php5-gd
php5-gearman
php5-gender
php5-geoip
php5-gmp
php5-gnupg
php5-http
php5-igbinary
php5-imagick
php5-imap
php5-inotify
php5-interbase
php5-intl
php5-jsmin
php5-json
php5-judy
php5-lasso
php5-ldap
php5-leveldb
php5-libevent
php5-librdf
php5-lzf
php5-mailparse
php5-mapscript
php5-mcrypt
php5-memcache
php5-memcached
php5-mogilefs
php5-mongo
php5-msgpack
php5-mssql
php5-mysql
php5-mysqlnd
php5-oauth
php5-odbc
php5-opcache
php5-pgsql
php5-phalcon
php5-phpunit
php5-pinba
php5-protocolbuffers
php5-ps
php5-pspell
php5-quickhash
php5-radius
php5-rar
php5-readline
php5-recode
php5-redis
php5-scream
php5-scrypt
php5-solr
php5-sphinx
php5-spidermonkey
php5-sqlite
php5-ssdeep
php5-ssh2
php5-stats
php5-stem
php5-stomp
php5-sundown
php5-svm
php5-svn
php5-swoole
php5-tidy
php5-timezonedb
php5-tokyo_tyrant
php5-uuid
php5-varnish
php5-xcache
php5-xdebug
php5-xhprof
php5-xmlrpc
php5-xsl
php5-yaf
php5-yaml
php5-yar
php7
php7-composer
php7-curl
php7-gd
php7-imap
php7-interbase
php7-intl
php7-json
php7-ldap
php7-mcrypt
php7-memcached
php7-mysql
php7-odbc
php7-opcache
php7-pgsql
php7-phpunit
php7-pspell
php7-readline
php7-recode
php7-redis
php7-sqlite
php7-tidy
php7-timezonedb
php7-xmlrpc
postgresql
ps_mem
r
rake
redis-server
rkhunter
rsync
rsync_cp
rsync_mv
rsync_rm
rtorrent
ruby
scout_realtime
scrypt
siege
ssdeep
strace
supervisor
tesseract-ocr
tmux
tuning-primer
units
unzip
vim
virt-what
vmtouch
wkhtmltopdf
yui-compressor
zip
zsh
```

Credits
=======

This Bash script is inspired by:

* [fideloper/Vaprobash](https://github.com/fideloper/Vaprobash)
* [kr41/bash-booster](https://bitbucket.org/kr41/bash-booster)
* [Linode StackScripts](http://www.linode.com/stackscripts/)
* [lowendbox/lowendscript](https://github.com/lowendbox/lowendscript)
* [perusio/nginx_ensite](https://github.com/perusio/nginx_ensite)
* [TigersWay/VPS](https://github.com/TigersWay/VPS)
* [Xeoncross/lowendscript](https://github.com/Xeoncross/lowendscript)

License
=======

MIT
