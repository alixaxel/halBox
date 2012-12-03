halBox
======

Bash script with a bit of unicornian magic dust to set up and tweak your Debian/Ubuntu server.

Usage
=====

	wget -q https://github.com/alixaxel/halBox/archive/master.tar.gz -O ~/halBox.tar.gz && tar -xzvf ~/halBox.tar.gz && chmod +x ~/halBox-master/halBox.sh && ~/halBox-master/halBox.sh

Screenshots
===========

Wait for the stable release first! ;)

To-Do
=====

* add ElasticSearch?
* add build-essential
* tweak MongoDB setup
* take care of innotop Perl dependencies
* benchmark MySQL Server vs Percona Server
* provide a better default list for node.js modules
* make sure all the packages install correctly on Debian
* tweak chkrootkit, clamav, maldet and rkhunter installs
* assess if either nginx `fastcgi_cache` or Varnish are viable to implement

Credits
=======

This script is inspired by [TigersWay/VPS](https://github.com/TigersWay/VPS), [Xeoncross/lowendscript](https://github.com/Xeoncross/lowendscript) and [lowendbox/lowendscript](https://github.com/lowendbox/lowendscript), as well as some [Linode StackScripts](http://www.linode.com/stackscripts/).
