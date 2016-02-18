FROM samtayuk/nginx-php:php7
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV OWNCLOUD_VERSION 8.2.2

RUN cd /app && curl https://download.owncloud.org/community/owncloud-{$OWNCLOUD_VERSION}.tar.bz2 | tar xj \
	&& mkdir /data \
    && chown -R www-data:www-data /data \
    && chown -R www-data:www-data /app/owncloud \
    && echo "*/15  *  *  *  * php -f /app/owncloud/cron.php" >> tmp-cron \
    && crontab tmp-cron \
    && rm -f tmp-cron \
    && echo "apc.enable_cli=1" >> /etc/php/7.0/cli/php.ini

COPY docker-entrypoint.sh default.config.php default.conf /app/
RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT /app/docker-entrypoint.sh

VOLUME ['/data', '/app/owncloud/config']