halBox
======

Bash script with a bit of unicornian magic dust to set up and tweak your Debian/Ubuntu server.

***Nota bene:*** halBox ships with the [EICAR test virus file](http://en.wikipedia.org/wiki/EICAR_test_file) to assess ClamAV.

Setup
=====

First of all, if your terminal locale is not `en_US.UTF-8` be sure to do:
    
    locale-gen lc_CC.UTF-8

To avoid getting a bunch of annoying errors due to non-existing locales.

---

As *root*, copy+paste the following on your command-line:

    cd ~ && wget -q https://github.com/alixaxel/halBox/archive/master.tar.gz -O ~/halBox.tar.gz && tar -xzvf ~/halBox.tar.gz && chmod +x ~/halBox-master/halBox.sh && ~/halBox-master/halBox.sh

A default install should take less than 5 minutes to complete.

Memory Usage
============

halBox is VPS-oriented, it has been crafted to consume as little memory as possible.

Here's what a default install looks like after a fresh *reboot* (under Ubuntu 12.04 LTS *minimal*):

    # ps_mem
     Private  +   Shared  =  RAM used       Program

    100.0 KiB +  40.5 KiB = 140.5 KiB       sleep
     80.0 KiB +  85.0 KiB = 165.0 KiB       dash
    104.0 KiB +  83.0 KiB = 187.0 KiB       ondemand
    128.0 KiB +  71.0 KiB = 199.0 KiB       syslogd
    304.0 KiB +  75.5 KiB = 379.5 KiB       cron
    304.0 KiB + 105.0 KiB = 409.0 KiB       xinetd
    476.0 KiB +  89.0 KiB = 565.0 KiB       exim4
    472.0 KiB + 116.5 KiB = 588.5 KiB       dropbear
    748.0 KiB + 119.5 KiB = 867.5 KiB       init
    664.0 KiB + 598.5 KiB =   1.2 MiB       nginx (3)
    784.0 KiB +   3.3 MiB =   4.1 MiB       php5-fpm (3)
      7.1 MiB + 160.0 KiB =   7.2 MiB       mysqld
    ---------------------------------
                             16.0 MiB
    =================================

Of course, some features and configurations had to be sacrificed, most notably:

* InnoDB engine is disabled
* MyISAM [`key_buffer_size` directive](http://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_key_buffer_size) is set to 8MB
* *non*-PDO database drivers are disabled by default (this includes `mysql` and `mysqli`)

As of version 0.26.0, halBox comes with two custom scripts for nginx:

* [`n1ensite`](https://github.com/alixaxel/halBox/blob/master/halBox/nginx-light/usr/sbin/n1ensite) (mimics Apache [`a2ensite`](http://manpages.ubuntu.com/manpages/precise/man8/a2ensite.8.html))
* [`n1dissite`](https://github.com/alixaxel/halBox/blob/master/halBox/nginx-light/usr/sbin/n1dissite) (mimics Apache [`a2dissite`](http://manpages.ubuntu.com/manpages/precise/man8/a2dissite.8.html))

As of version 0.31.0, halBox also ships with custom rsync LIFO directory utilities:

* [`rsync_cp`](https://github.com/alixaxel/halBox/blob/master/halBox/rsync/usr/sbin/rsync_cp)
* [`rsync_mv`](https://github.com/alixaxel/halBox/blob/master/halBox/rsync/usr/sbin/rsync_mv)
* [`rsync_rm`](https://github.com/alixaxel/halBox/blob/master/halBox/rsync/usr/sbin/rsync_rm)

Screenshots *(Ubuntu)*
======================

*These may not reflect the current version of the script / packages.*

![Pre-Requesites and Must-Haves](http://i.imgur.com/h2y7q.png "Pre-Requesites and Must-Haves")
---
![Package Selection](http://i.imgur.com/pXFaf.png "Package Selection")
---
![PHP Extensions](http://i.imgur.com/dMMWM.png "PHP Extensions")
---
![MySQL Root Password](http://i.imgur.com/8ptkh.png "MySQL Root Password")
---
![Progress](http://i.imgur.com/6frQn.png "Progress")
---
![index.html](http://i.imgur.com/K8fg8.png "index.html")
---
![info.php](http://i.imgur.com/Ftld3.png "info.php")

Credits
=======

This script is inspired by:
* [TigersWay/VPS](https://github.com/TigersWay/VPS)
* [Xeoncross/lowendscript](https://github.com/Xeoncross/lowendscript)
* [lowendbox/lowendscript](https://github.com/lowendbox/lowendscript)
* [Linode StackScripts](http://www.linode.com/stackscripts/)
* [perusio/nginx_ensite](https://github.com/perusio/nginx_ensite)
