FROM php:7.2-apache
MAINTAINER 'samkcell@yahoo.fr'

RUN apt-get update \
	&& apt-get install -y \
		wget unzip systemd

RUN wget \
  -O /tmp/dolibarr-10-0 \
  https://codeload.github.com/Dolibarr/dolibarr/zip/10.0

RUN unzip -d /usr/src /tmp/dolibarr-10-0 \
	&& chown -R www-data:www-data /usr/src/dolibarr-10.0 \
	&& rm -fr /var/www/html \
	&& cp -a /usr/src/dolibarr-10.0 /var/www/html \
        && rm -fr /tmp/dolibarr-10-0

RUN touch htdocs/conf/conf.php \
    && chown www-data htdocs/conf/conf.php

RUN mkdir documents \
    && chown www-data documents

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN apt-get update && apt-get install -y \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libpng-dev \
   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install -j$(nproc) gd 

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN docker-php-ext-install calendar && docker-php-ext-configure calendar

RUN sed -i -e  "s/\/var\/www\/html/\/var\/www\/html\/htdocs/g" \
    /etc/apache2/sites-enabled/000-default.conf


CMD /usr/sbin/apache2ctl -D FOREGROUND


