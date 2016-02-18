#!/bin/bash
set -e

trap 'echo oh, I am slain; exit' INT

if [ ! -e '/app/owncloud/config/config.php' ]; then
    echo "*** FIRST TIME RUN"
    echo "*** Copying default config file"
    cp /app/default.config.php /app/owncloud/config/config.php
    chown www-data:www-data /app/owncloud/config/config.php

    echo "*** Changing owner on data volume to www-data"
    chown -R www-data:www-data /data
fi

if [ -z "$VIRTUAL_LOCATION" ]; then
    VIRTUAL_LOCATION="/"
fi

if [ "$VIRTUAL_LOCATION" == "/" ]; then
    DOC_ROOT="/app/owncloud/"
    LOCATION="/"
else
    DOC_ROOT="/app/public/"
    LOCATION="/$VIRTUAL_LOCATION/"
    mkdir -p /app/public
    ln -s /app/owncloud /app/public/$VIRTUAL_LOCATION
fi

if [ -e '/etc/nginx/conf.d/default.conf' ]; then
    rm -f /etc/nginx/conf.d/default.conf
fi

sed -e "s,ROOT,${DOC_ROOT},g" -e "s,VIRTUAL_LOCATION,${LOCATION},g" /app/default.conf >> /etc/nginx/conf.d/default.conf

echo "$@"
echo "$1"

if [ -z "$@" ]; then
    /usr/local/bin/forego start -r
else
    exec "$@"
fi