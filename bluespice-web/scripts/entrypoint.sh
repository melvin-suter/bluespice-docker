#!/bin/bash

# Copy if not existing
find /opt/bluespice_orig/settings.d/  -maxdepth 1 -type d | tail -n+2 | sed "s;/opt/bluespice_orig/;;" | while read line ; do   test -d /opt/bluespice/$line || cp -R /opt/bluespice_orig/$line /opt/bluespice/$line; done

# Copy all
/bin/mv -f /opt/bluespice_orig/extensions/* /opt/bluespice/extensions

docker-php-entrypoint --user 1000:1000