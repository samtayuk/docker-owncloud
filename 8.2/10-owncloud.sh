#!/bin/bash
set -eo pipefail

if [ ! -e '/app/owncloud/config/config.php' ]; then
    echo "  ** Copying default config file"
    cp /app/default.config.php /app/owncloud/config/config.php
    chown www-data:www-data /app/owncloud/config/config.php
fi

echo "  ** Changing owner on data volume to www-data"
chown -R www-data:www-data /data

if [ -z "$VIRTUAL_LOCATION" ]; then
    echo "  ** No VIRTUAL_LOCATION set defaulting to /"
    VIRTUAL_LOCATION="/"
fi

echo "  ** Setting up OwnCloud in Subdirectory: $VIRTUAL_LOCATION"
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