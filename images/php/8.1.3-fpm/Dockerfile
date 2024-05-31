FROM php:8.1.3-fpm

LABEL maintainer="Bestworlds <dev@bestworlds.com>"

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-intl --enable-opcache --enable-zip

RUN apt-get update

#Install crontab
RUN apt-get install -y cron

RUN apt-get install -y supervisor

RUN update-rc.d cron defaults

RUN \
  apt-get install -y \
  htop \
  mc \
  nano \
  default-mysql-client \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev \
  libpq-dev

RUN \
  /usr/local/bin/docker-php-ext-install \
  dom \
  pcntl \
  phar \
  posix

# Configure PHP
# php module build deps
RUN \
  apt-get install -y \
    wget \
    cron \
    default-mysql-client \
    git \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    lsof \
    mailutils \
    msmtp \
    nodejs \
    procps \
    strace \
    vim \
    zip \
    zlib1g-dev

RUN pecl channel-update pecl.php.net && pecl install \
    imagick-3.7.0 \
    redis-6.0.2 \
    ssh2-1.3.1 \
    swoole-5.1.1 \
    xdebug-3.2.2 \
  && pecl clear-cache \
  && rm -rf /tmp/pear

RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip \
  && docker-php-ext-enable \
    imagick \
    redis \
    ssh2 \
    xdebug

#####################################
# LDAP:
#####################################
RUN \
    apt-get update && \
    apt-get install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

# Install Node, NVM, NPM and Grunt, Gulp
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn \
    && npm install gulp-cli -g

# Magento 2.3.2 
# https://github.com/magento/magento2/issues/23405 
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list

RUN apt-get update && apt-get -t bullseye-backports install -y

# Install APCU
RUN echo no | pecl install -o -f apcu && docker-php-ext-enable apcu

# Install MongoDB
RUN pecl install mongodb && docker-php-ext-enable mongodb.so

# Install fontforge https://github.com/sapegin/grunt-webfont#installation
RUN apt-get install -y fontforge ttfautohint

# Create .ssh folder
RUN mkdir -p /var/www/.ssh

# Set www-data as owner for /var/www
RUN chown -R www-data:www-data /var/www/
RUN chmod -R g+w /var/www/

# Create log folders
RUN rm -rf /var/log/php-fpm # Delete if exist
RUN mkdir -p /var/log/php-fpm && \
    touch /var/log/php-fpm/access.log && \
    touch /var/log/php-fpm/fpm-error.log && \
    touch /var/log/php-fpm/fpm-php.www.log && \
    chown -R www-data:www-data /var/log/php-fpm

RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN echo no | pecl install -o -f redis && docker-php-ext-enable redis

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd

# Add users
RUN groupadd -g 501  kirk &&  useradd -g 501  -u 501  -d /var/www/html -s /bin/bash kirk
RUN groupadd -g 1000 warp &&  useradd -g 1000 -u 1000 -d /var/www/html -s /bin/bash warp
RUN groupadd -g 1001 spock && useradd -g 1001 -u 1001 -d /var/www/html -s /bin/bash spock
RUN groupadd -g 1002 scott && useradd -g 1002 -u 1002 -d /var/www/html -s /bin/bash scott

# Add users to group www-data
RUN usermod -aG 501  www-data
RUN usermod -aG 1000 www-data
RUN usermod -aG 1001 www-data
RUN usermod -aG 1002 www-data

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/* && \
  rm -rf /var/lib/apt/lists/*

#ioncube
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
  tar -zxf ioncube_loaders_lin_x86-64.tar.gz && \
  mv ioncube/ioncube_loader_lin_8.1.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/ioncube.so && \
  echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20210902/ioncube.so" > /usr/local/etc/php/conf.d/10-php-ext-ioncube.ini
