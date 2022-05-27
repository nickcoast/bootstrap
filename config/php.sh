#!/bin/bash
#20201214 - adapted from FBN vagrant machine setup. Not tested yet.

#imports SCRIPT_PATH and SITE_NAME

#install PHP 8.1 - default for ubuntu 22.04
PHP_VER="8.1"
#from https://computingforgeeks.com/how-to-install-php-on-ubuntu-2/

#do apt update and upgrade, and reboot, before running this script. Should be done in bootstrap.sh I think
apt update
apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
apt-get -y update

apt -y install php${PHP_VER}

#get php version dynamically
#PHP_VER=$(php-config --version | egrep -o '^[0-9]*\.[0-9]')

#cli needed separately or no?
#apt-get install -y php7.0-cli
apt install -y php${PHP_VER}-dev
apt install -y libapache2-mod-php${PHP_VER}
apt install -y php${PHP_VER}-mysql

#required for phpmyadmin
apt install -y php${PHP_VER}-mbstring
#might be needed for phpmyadmin per https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-20-04
apt install -y php${PHP_VER}-mbstring php${PHP_VER}-zip php${PHP_VER}-gd php${PHP_VER}-curl
#package '~~~ whatever the package name is ~~~' has no installation candidate
#maybe built in?
apt install -y php${PHP_VER}-json


#in case php 7.4 is already installed
#a2dismod php7.4
a2enmod php${PHP_VER}


#apt install -y php8.0-xdebug

#PHP_VER was gotten dynamically here before

mv /etc/php/$PHP_VER/apache2/php.ini /etc/php/$PHP_VER/apache2/php.ini.orig
#ln -s $SCRIPT_PATH/config/php8/php.ini /etc/php/$PHP_VER/apache2/php.ini
# $SCRIPT_PATH apparently already includes "config"? So above path failed
ln -s $SCRIPT_PATH/php8/php.ini /etc/php/$PHP_VER/apache2/php.ini
