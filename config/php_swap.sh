#!/bin/bash

#20201214 - adapted from FBN vagrant machine setup. Not tested yet.

#install PHP 8.0
#from https://computingforgeeks.com/how-to-install-php-on-ubuntu-2/

#do apt update and upgrade, and reboot, before running this script. Should be done in bootstrap.sh I think
apt update
apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
apt-get -y update

apt -y install php8.0


#cli needed separately or no?
#apt-get install -y php7.0-cli
apt-get install -y php8.0-dev
apt-get install -y libapache2-mod-php8.0

#get php version dynamically
PHP_VER=$(php-config --version | egrep -o '^[0-9]*\.[0-9]')

mv /etc/php/$PHP_VER/apache2/php.ini /etc/php/$PHP_VER/apache2/php.ini.orig
ln -s $SCRIPT_PATH/config/php8/php.ini /etc/php/$PHP_VER/apache2/php.ini

