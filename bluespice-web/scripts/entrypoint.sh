#!/bin/bash

SECRET_KEY="$(hexdump -vn16 -e'4/4 "%08x" 2 "\n"' /dev/urandom)$(hexdump -vn16 -e'4/4 "%08x" 2 "\n"' /dev/urandom)"
LOCALSETTINGS_TARGET="/var/www/html/LocalSettings.php"

# For Testing create dirs
test -d /images || mkdir -p /images
test -d /settings || mkdir -p /settings/settings.d
test -d /extensions || mkdir -p /extensions

# Copy if not existing
find /var/www/html_original/settings.d/  -maxdepth 1 -type d | tail -n+2 | sed "s;/var/www/html_original/;;" | while read line ; do   test -d /var/www/html/$line || cp -R /var/www/html_original/$line /var/www/html/$line; done

# Copy all
test -d /var/www/html/extensions || mkdir /var/www/html/extensions
/bin/mv -f /var/www/html_original/extensions/* /var/www/html/extensions

# Run Installer if needed

if [ -f /settings/LocalSettings.php ] ; then
    [ -n "$MARIADB_USER" ] && php maintenance/install.php --conf $LOCALSETTINGS_TARGET "$BLUESPICE_SITE_NAME" "$BLUESPICE_INITIAL_ADMIN_NAME" --pass "$BLUESPICE_INITIAL_ADMIN_PASSWORD" --dbname "$MARIADB_DATABASE" --dbpass "$MARIADB_PASSWORD" --dbserver "$MARIADB_HOST" --dbuser "$MARIADB_USER"
    [ -n "$MARIA_USER" ] && php maintenance/install.php --conf $LOCALSETTINGS_TARGET "$BLUESPICE_SITE_NAME" "$BLUESPICE_INITIAL_ADMIN_NAME" --pass "$BLUESPICE_INITIAL_ADMIN_PASSWORD" --dbname "$MARIA_DATABASE" --dbpass "$MARIA_PASSWORD" --dbserver "$MARIA_HOST" --dbuser "$MARIA_USER"
    [ -n "$MYSQL_USER" ] && php maintenance/install.php --conf $LOCALSETTINGS_TARGET "$BLUESPICE_SITE_NAME" "$BLUESPICE_INITIAL_ADMIN_NAME" --pass "$BLUESPICE_INITIAL_ADMIN_PASSWORD" --dbname "$MYSQL_DATABASE" --dbpass "$MYSQL_PASSWORD" --dbserver "$MYSQL_HOST" --dbuser "$MYSQL_USER"

    # Create LocalSettings.php
    /bin/cp -f /opt/bluespice/LocalSettings.php /settings/LocalSettings.php

fi

# Replace Vars
[ -n "$BLUESPICE_SITE_NAME" ] && sed -i "s;##BLUESPICE_SITE_NAME##;$BLUESPICE_SITE_NAME;" $LOCALSETTINGS_TARGET
[ -n "$BLUESPICE_URL" ] && sed -i "s;##BLUESPICE_URL##;$BLUESPICE_URL;" $LOCALSETTINGS_TARGET
[ -n "$MARIADB_HOST" ] && sed -i "s;##MYSQL_HOST##;$MARIADB_HOST;" $LOCALSETTINGS_TARGET
[ -n "$MARIADB_USER" ] && sed -i "s;##MYSQL_USER##;$MARIADB_USER;" $LOCALSETTINGS_TARGET
[ -n "$MARIADB_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MARIADB_PASSWORD;" $LOCALSETTINGS_TARGET
[ -n "$MARIADB_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MARIADB_DATABASE;" $LOCALSETTINGS_TARGET
[ -n "$MARIA_HOST" ] && sed -i "s;##MYSQL_HOST##;$MARIA_HOST;" $LOCALSETTINGS_TARGET
[ -n "$MARIA_USER" ] && sed -i "s;##MYSQL_USER##;$MARIA_USER;" $LOCALSETTINGS_TARGET
[ -n "$MARIA_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MARIA_PASSWORD;" $LOCALSETTINGS_TARGET
[ -n "$MARIA_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MARIA_DATABASE;" $LOCALSETTINGS_TARGET
[ -n "$MYSQL_HOST" ] && sed -i "s;##MYSQL_HOST##;$MYSQL_HOST;" $LOCALSETTINGS_TARGET
[ -n "$MYSQL_USER" ] && sed -i "s;##MYSQL_USER##;$MYSQL_USER;" $LOCALSETTINGS_TARGET
[ -n "$MYSQL_PASSWORD" ] && sed -i "s;##MYSQL_PASSWORD##;$MYSQL_PASSWORD;" $LOCALSETTINGS_TARGET
[ -n "$MYSQL_DATABASE" ] && sed -i "s;##MYSQL_DATABASE##;$MYSQL_DATABASE;" $LOCALSETTINGS_TARGET
[ -n "$BLUESPICE_TIMEZONE" ] && sed -i "s;##BLUESPICE_TIMEZONE##;$BLUESPICE_TIMEZONE;" $LOCALSETTINGS_TARGET
[ -n "$BLUESPICE_LANGUAGE" ] && sed -i "s;##BLUESPICE_LANGUAGE##;$BLUESPICE_LANGUAGE;" $LOCALSETTINGS_TARGET
[ -n "$SECRET_KEY" ] && sed -i "s;##SECRET_KEY##;$SECRET_KEY;" $LOCALSETTINGS_TARGET



docker-php-entrypoint
apache2-foreground