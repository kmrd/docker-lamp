#
# Ubunut-based PHP LAMP stack
#
#
# Building:
# docker build -t kmrd/lamp .
#
#
# Usage:
# ------------------
# OSX / Ubuntu:
# docker run -it --rm --name lamp -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/lamp
#
# Windows:
# docker run -it --rm --name lamp -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/lamp
#
#
FROM ubuntu:16.04
MAINTAINER David Reyes <david@thoughtbubble.ca>

# Environments vars
ENV TERM=xterm
ENV DEBIAN_FRONTEND noninteractive 
# ENV LOG_STDOUT **Boolean**
# ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
# ENV TERM dumb


#-----------------------#
# Installs              #
#-----------------------#
RUN apt-get update
RUN apt-get -y upgrade

# COPY debconf.selections /tmp/
# RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y \
## --fix-missing install \
  curl \
  apt-transport-https \
  git \
  nano \
  lynx-cur \
  sudo \
  lsof \
  dos2unix \
  unzip \
  nodejs \
  npm \
  composer \
  tree \
  vim \
  curl \
  ftp

RUN apt-get install -y \
  php7.0 \
  php7.0-bz2 \
  php7.0-cgi \
  php7.0-cli \
  php7.0-common \
  php7.0-curl \
  php7.0-dev \
  php7.0-enchant \
  php7.0-fpm \
  php7.0-gd \
  php7.0-gmp \
  php7.0-imap \
  php7.0-interbase \
  php7.0-intl \
  php7.0-json \
  php7.0-ldap \
  php7.0-mcrypt \
  php7.0-mysql \
  php7.0-odbc \
  php7.0-opcache \
  php7.0-pgsql \
  php7.0-phpdbg \
  php7.0-pspell \
  php7.0-readline \
  php7.0-recode \
  php7.0-snmp \
  php7.0-sqlite3 \
  php7.0-sybase \
  php7.0-tidy \
  php7.0-xmlrpc \
  php7.0-xsl


# Install supervisor (not strictly necessary)
# RUN apt-get -y --fix-missing install supervisor && \
#       mkdir -p /var/log/supervisor


# Install Apache 
RUN apt-get install apache2 libapache2-mod-php7.0 -y


# Install MariaSQL
RUN apt-get install mariadb-common mariadb-server mariadb-client -y


RUN apt-get install postfix -y

RUN npm install -g bower grunt-cli gulp


#-----------------------#
# Configurations        #
#-----------------------#

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node


# Configure php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/display_errors\s*=\s*Off/display_errors = On/g" /etc/php/7.0/fpm/php.ini


# Setting Permissions
RUN chown -R www-data:www-data /var/www/html


VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
WORKDIR /var/www/html


EXPOSE 80
EXPOSE 443
EXPOSE 3306


#-----------------------#
# Final Action          #
#-----------------------#
# Use entrypoint script
ADD conf/entrypoint.sh /usr/sbin/entrypoint.sh
RUN dos2unix /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh
# ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
CMD ["/usr/sbin/entrypoint.sh"]

#Start nginx
# RUN nginx
# CMD ["nginx", "-g", "daemon off"]

#Start supervisor
# CMD ["/usr/bin/supervisord"]


# CMD ["/bin/bash"]







#CMD ["nginx"]

# CMD ["nginx", "-g", "daemon off"]

# Composer install
# RUN curl -sS https://getcomposer.org/installer | php
# RUN mv composer.phar /usr/local/bin/composer
