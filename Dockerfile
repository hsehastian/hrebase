FROM ubuntu:18.04

# FIX NON INTERACTIVE
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y upgrade

# INSTALL LOCALES
RUN apt-get update \
	&& apt-get install -y locales

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen

# INSTALL COMMON SOFTWARE
RUN apt-get update \
  && apt-get install -y software-properties-common \
  curl \
  git \
  unzip

# ADD EXTERNAL REPO
RUN apt-get update \
  && add-apt-repository ppa:ondrej/php

# INSTALL PHP AND MODULES
RUN apt-get update \
  && apt-get install -y php5.6 \
  php5.6-cli \
  php5.6-mysql \
  php5.6-mbstring \
  php5.6-xml \
  php5.6-gd \
  php5.6-curl \
  php5.6-bcmath \
  php5.6-mcrypt \
  php5.6-intl \
  php5.6-xsl \
  php5.6-zip \
  libapache2-mod-php5.6

# INSTALL COMPOSER
RUN apt-get update \
  && curl -sS https://getcomposer.org/installer -o composer-setup.php \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# INSTALL DRUSH

# INSTALL APACHE2
RUN apt-get update \
  && apt-get install -y --no-install-recommends apache2

# ENABLE APACHE2 MOD
RUN a2enmod rewrite \
  headers \
  proxy \
  proxy_connect \
  proxy_ftp \
  proxy_http \
  proxy_fcgi \
  proxy_scgi

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# ENABLE APACHE MPM PREFORK
# RUN a2dismod mpm_event && a2enmod mpm_prefork

# RUN service apache2 restart

# ADD ~/projects/hreasily /var/www/hreasily

# EXPOSE 80
# EXPOSE 88


# CLEANUP
RUN apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/cache/*

CMD /usr/sbin/apache2ctl -D FOREGROUND
