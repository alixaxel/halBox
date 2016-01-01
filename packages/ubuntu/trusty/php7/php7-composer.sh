#!/usr/bin/env bash

wget -q http://getcomposer.org/composer.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer && cp -r $halBox_Base/overlay/composer/. /

if [[ -f /etc/cron.monthly/composer ]]; then
    chmod +x /etc/cron.monthly/composer
fi
