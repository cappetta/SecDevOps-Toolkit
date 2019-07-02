#FROM php:7.2-fpm
FROM php:7.2-apache
MAINTAINER Simon Frost <s.frost@frostnet.co.uk>
MAINTAINER Cappetta <tcappetta@tenable.com>

# https://github.com/sensson/docker-magento2/blob/master/Dockerfile

  # Install Magento 2 dependencies
  RUN apt-get update && apt-get install -y \
          cron \
          git \
          libfreetype6-dev \
          libjpeg62-turbo-dev \
          libmcrypt-dev \
          libxml2-dev \
          libxslt1-dev \
          libicu-dev \
          mysql-client \
          xmlstarlet \
          vim \
      && docker-php-ext-install -j$(nproc) bcmath \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd \
      && docker-php-ext-install -j$(nproc) json \
      && docker-php-ext-install -j$(nproc) iconv \
      && docker-php-ext-install -j$(nproc) openssl \
      && docker-php-ext-install -j$(nproc) mbstring \
      && docker-php-ext-install -j$(nproc) pcntl \
      && docker-php-ext-install -j$(nproc) soap \
      && docker-php-ext-install -j$(nproc) xsl \
      && docker-php-ext-install -j$(nproc) intl \
      && docker-php-ext-install -j$(nproc) pdo \
      && docker-php-ext-install -j$(nproc) pdo_mysql \
      && pecl install redis-3.1.0 \
      && docker-php-ext-enable redis \
      && a2enmod rewrite headers \
      && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  gd \
  intl \
  mbstring \
  pdo_mysql \
  soap \
  xsl \
  zip

RUN apt-get update -y && \
    apt-get install -y libmcrypt-dev && \
    pecl install mcrypt-1.0.1 && \
    docker-php-ext-enable mcrypt

ARG WITH_XDEBUG=true

RUN if [ $WITH_XDEBUG = "true" ] ; then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
        echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi ;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
COPY etc/php.ini /usr/local/etc/php/conf.d/00_magento.ini
COPY etc/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY etc/apache.conf /etc/apache2/conf-enabled/00_magento.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV MARIADB_HOSTNAME="mariadb" MARIADB_USERNAME="magento" MARIADB_PASSWORD="magento" MARIADB_DATABASE="magento" CRYPT_KEY="" \
    URI="http://localhost" ADMIN_USERNAME="admin" ADMIN_PASSWORD="Password123" ADMIN_FIRSTNAME="admin" \
    ADMIN_LASTNAME="admin" ADMIN_EMAIL="admin@localhost.com" CURRENCY="USD" LANGUAGE="en_US" \
    TIMEZONE="America/New_York" BACKEND_FRONTNAME="admin" CONTENT_LANGUAGES="en_US"

#COPY start-container /usr/local/bin/start-container
#RUN chmod +x /usr/local/bin/start-container

EXPOSE 80
EXPOSE 443
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
#CMD ["start-container"]