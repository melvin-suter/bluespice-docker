FROM php:8.2-apache

ENV APACHE_DOCUMENT_ROOT /opt/bluespice
ENV APACHE_HTTP_PORT 3000
ENV APACHE_HTTPS_PORT 3001

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN sed -ri -e 's!80!${APACHE_HTTP_PORT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!443!${APACHE_HTTPS_PORT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN docker-php-ext-install curl \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install json \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mysql \
    && docker-php-ext-install opcache \
    && docker-php-ext-install tidy \
    && docker-php-ext-install xml \
    && docker-php-ext-install zip

RUN wget https://bluespice.com/filebase/bluespice-free/ -o /opt/setup.zip \
    && unzip setup.zip \
    && rm -f setup.zip
    
RUN mkdir -p /opt/bluespice_original \
    && mv /opt/bluespice/extensions /opt/bluespice_original/ \
    && mv /opt/bluespice/images /opt/bluespice_original/ \
    && mv /opt/bluespice/settings /opt/bluespice_original/ \
    && ln -s /images /opt/bluespice/images \
    && ln -s /settings/settings.d /opt/bluespice/settings.d \
    && ln -s /settings/LocalSettings.php /opt/bluespice/LocalSettings.php

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chown 1000:1000 /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]