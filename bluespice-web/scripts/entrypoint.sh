#!/bin/bash

# Copy if not existing
find /opt/bluespice_original/settings.d/  -maxdepth 1 -type d | tail -n+2 | sed "s;/opt/bluespice_original/;;" | while read line ; do   test -d /opt/bluespice/$line || cp -R /opt/bluespice_original/$line /opt/bluespice/$line; done

# Copy all
test -d /opt/bluespice/extensions || mkdir /opt/bluespice/extensions
/bin/mv -f /opt/bluespice_original/extensions/* /opt/bluespice/extensions

docker-php-entrypoint