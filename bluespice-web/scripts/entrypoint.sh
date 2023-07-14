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
test -f /settings/LocalSettings.php || cp /var/www/html_original/LocalSettings.php /settings/LocalSettings.php

# Replace Vars
sed -i "s;##BLUESPICE_SITE_NAME##;$BLUESPICE_SITE_NAME;" /var/www/html/LocalSettings.php
sed -i "s;##BLUESPICE_URL##;$BLUESPICE_URL;" /var/www/html/LocalSettings.php
sed -i "s;##MYSQL_USER##;$MYSQL_USER;" /var/www/html/LocalSettings.php
sed -i "s;##MYSQL_PASSWORD##;$MYSQL_PASSWORD;" /var/www/html/LocalSettings.php
sed -i "s;##MYSQL_DATABASE##;$MYSQL_DATABASE;" /var/www/html/LocalSettings.php
sed -i "s;##BLUESPICE_TIMEZONE##;$BLUESPICE_TIMEZONE;" /var/www/html/LocalSettings.php
sed -i "s;##BLUESPICE_LANGUAGE##;$BLUESPICE_LANGUAGE;" /var/www/html/LocalSettings.php
sed -i "s;##SECRET_KEY##;$SECRET_KEY;" /var/www/html/LocalSettings.php

docker-php-entrypoint
apache2-foreground