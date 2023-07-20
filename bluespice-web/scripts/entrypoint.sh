#!/bin/bash

SECRET_KEY="$(hexdump -vn16 -e'4/4 "%08x" 2 "\n"' /dev/urandom)$(hexdump -vn16 -e'4/4 "%08x" 2 "\n"' /dev/urandom)"

# For Testing create dirs
test -d /images || mkdir -p /images
test -d /settings || mkdir -p /settings/settings.d
test -d /extensions || mkdir -p /extensions

# Copy if not existing
find /var/www/html_original/settings.d/  -maxdepth 1 -type d | tail -n+2 | sed "s;/var/www/html_original/;;" | while read line ; do   test -d /var/www/html/$line || cp -R /var/www/html_original/$line /var/www/html/$line; done

# Copy all
test -d /var/www/html/extensions || mkdir /var/www/html/extensions
/bin/mv -f /var/www/html_original/extensions/* /var/www/html/extensions

# Create LocalSettings.php if needed
test -f /settings/LocalSettings.php || cp /opt/bluespice/LocalSettings.php /settings/LocalSettings.php

# Replace Vars
[ -n "$BLUESPICE_SITE_NAME" ] && sed -i "s;##BLUESPICE_SITE_NAME##;$BLUESPICE_SITE_NAME;" /var/www/html/LocalSettings.php
[ -n "$BLUESPICE_URL" ] && sed -i "s;##BLUESPICE_URL##;$BLUESPICE_URL;" /var/www/html/LocalSettings.php
[ -n "$MARIADB_HOST" ] && sed -i "s;##MYSQL_HOST##;$MARIADB_HOST;" /var/www/html/LocalSettings.php
[ -n "$MARIADB_USER" ] && sed -i "s;##MYSQL_USER##;$MARIADB_USER;" /var/www/html/LocalSettings.php
[ -n "$MARIADB_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MARIADB_PASSWORD;" /var/www/html/LocalSettings.php
[ -n "$MARIADB_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MARIADB_DATABASE;" /var/www/html/LocalSettings.php
[ -n "$MARIA_HOST" ] && sed -i "s;##MYSQL_HOST##;$MARIA_HOST;" /var/www/html/LocalSettings.php
[ -n "$MARIA_USER" ] && sed -i "s;##MYSQL_USER##;$MARIA_USER;" /var/www/html/LocalSettings.php
[ -n "$MARIA_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MARIA_PASSWORD;" /var/www/html/LocalSettings.php
[ -n "$MARIA_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MARIA_DATABASE;" /var/www/html/LocalSettings.php
[ -n "$MYSQL_HOST" ] && sed -i "s;##MYSQL_HOST##;$MYSQL_HOST;" /var/www/html/LocalSettings.php
[ -n "$MYSQL_USER" ] && sed -i "s;##MYSQL_USER##;$MYSQL_USER;" /var/www/html/LocalSettings.php
[ -n "$MYSQL_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MYSQL_PASSWORD;" /var/www/html/LocalSettings.php
[ -n "$MYSQL_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MYSQL_DATABASE;" /var/www/html/LocalSettings.php
[ -n "$BLUESPICE_TIMEZONE" ] && sed -i "s;##BLUESPICE_TIMEZONE##;$BLUESPICE_TIMEZONE;" /var/www/html/LocalSettings.php
[ -n "$BLUESPICE_LANGUAGE" ] && sed -i "s;##BLUESPICE_LANGUAGE##;$BLUESPICE_LANGUAGE;" /var/www/html/LocalSettings.php
[ -n "$SECRET_KEY" ] && sed -i "s;##SECRET_KEY##;$SECRET_KEY;" /var/www/html/LocalSettings.php

docker-php-entrypoint
apache2-foreground