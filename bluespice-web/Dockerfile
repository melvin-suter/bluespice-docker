FROM php:8.2-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html
ENV APACHE_HTTP_PORT 3000
ENV APACHE_HTTPS_PORT 3001
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2


RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN sed -ri -e 's!80!${APACHE_HTTP_PORT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!443!${APACHE_HTTPS_PORT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && apt-get install -y \
    libpspell-dev libfreetype6-dev libjpeg62-turbo-dev  \
    aspell-en \
    aspell-de  \
    apt-utils \
    libmcrypt-dev \
    libicu-dev \
    libxml2-dev  \
    libldb-dev \
    libldap2-dev  \
    libxml2-dev \
    libssl-dev \
    libxslt-dev \
    libpq-dev \
    libsqlite3-dev \
    libsqlite3-0 \
    libc-client-dev \
    libkrb5-dev \
    curl \
    libcurl3-dev \
    firebird-dev \
    libtidy-dev \
    libsnmp-dev \
    librecode0 \
    librecode-dev \
    libonig-dev \
    libzip-dev \
    wget \
    unzip

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu

RUN docker-php-ext-install ldap 
RUN docker-php-ext-install mbstring 
RUN docker-php-ext-install pdo pdo_mysql 
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache 
RUN docker-php-ext-install tidy 
RUN docker-php-ext-install xml 
RUN docker-php-ext-install zip 
RUN docker-php-ext-install -j$(nproc) gd 
RUN docker-php-ext-install -j$(nproc) intl 

RUN rm -rf /var/www/html
RUN mkdir -p /var/www/html_original

RUN wget https://bluespice.com/filebase/bluespice-free/ -O /opt/setup.zip \
    && cd /opt && unzip setup.zip \
    && rm -f setup.zip \
    && mv /opt/bluespice /opt/html \
    && mv /opt/html /var/www/
    
RUN mv /var/www/html/extensions /var/www/html_original/ \
    && mv /var/www/html/images /var/www/html_original/ \
    && mv /var/www/html/settings.d /var/www/html_original/

RUN ln -s /images /var/www/html/images \
    && ln -s /settings/settings.d /var/www/html/settings.d \
    && ln -s /settings/LocalSettings.php /var/www/html/LocalSettings.php

RUN mkdir -p /opt/bluespice
COPY scripts/entrypoint.sh /opt/bluespice/entrypoint.sh
COPY scripts/LocalSettings.php /opt/bluespice/LocalSettings.php
RUN chown 1000:1000 /opt/bluespice/entrypoint.sh && chmod +x /opt/bluespice/entrypoint.sh
RUN chown www-data:www-data -R /var/www/html
RUN chown www-data:www-data -R /var/www/html_original

WORKDIR ${APACHE_DOCUMENT_ROOT}

EXPOSE ${APACHE_HTTP_PORT}

ENTRYPOINT ["/opt/bluespice/entrypoint.sh"]