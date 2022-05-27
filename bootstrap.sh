#!/usr/bin/env bash
#Ubuntu 20 (+?)

#change script path to where config is, e.g. perhaps /vagrant/config for a vagrant VM
SCRIPT_PATH='/vagrant/config'
#change to site name for apache config files
SITE_NAME='mysite'
PHP_VER='8.1'

export SCRIPT_PATH
export SITE_NAME

#ubuntu downloads super slow without this fix in ubuntu 18.
#not sure if needed in ubuntu 20.
#mv /etc/gai.conf /etc/gai.conf.orig
#ln -s $SCRIPT_PATH/gai.conf /etc/gai.conf

timedatectl set-timezone America/Los_Angeles

apt-get -y update

#convert config files to unix style line endings
apt-get install -y dos2unix
$SCRIPT_PATH/d2u.sh

apt-get install -y apache2

#LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
#for ubuntu 20, php 7.4 installs by default

bash $SCRIPT_PATH/php.sh


#fix incorrect mcrypt.ini path to mcrypt.so - UBUNTU 16 TODO: check if this is necessary
#rm /etc/php/7.0/mods-available/mcrypt.ini
#ln -s ${SCRIPT_PATH}/mcrypt.ini /etc/php/7.0/mods-available/mcrypt.ini
#phpenmod mcrypt

#pecl not in ubuntu 20?
#pecl install xdebug

#xdebug.sh installs xdebug and places correct xdebug.ini in correct location
bash $SCRIPT_PATH/xdebug.sh

#XDEBUG
rm /etc/php/$PHP_VER/mods-available/xdebug.ini
ln -s ${SCRIPT_PATH}/xdebug.ini /etc/php/$PHP_VER/mods-available/xdebug.ini
phpenmod xdebug


#apt-get install -y php-mhash php-mcrypt php-curl php-cli php-mysql php-gd php-intl php-xsl

#install mysql server
bash $SCRIPT_PATH/mysql.sh

apt install -y php"$PHP_VER"-mysql

#not sure I need mcrypt for anything other than Magento 1.x. mcrypt requires PECL for PHP 7.2+
#apt install -y mcrypt php-mcrypt
apt install -y build-essential
apt install php-pear php-dev
pecl channel-update pecl.php.net
#echo '' works like -y


phpenmod mcrypt

echo "<?php phpinfo(); ?>" > /var/www/html/info.php


#This works but perhaps better to symlink
#cp /vagrant/vimrc /etc/vim/vimrc
#chown root:root /etc/vim/vimrc
#chmod 644 /etc/vim/vimrc

#next 3 lines may not work?
rm /etc/vim/vimrc
ln -s ${SCRIPT_PATH}/vimrc /etc/vim/vimrc
ln -s ${SCRIPT_PATH}/bash_alias.sh /etc/profile.d/bash_alias.sh


#APACHE/magento
a2enmod headers
a2enmod rewrite

#SYMLINK WWW for phpstorm files
if [ -d "/phpstorm" ] && [ ! -L "/var/www/html" ]
then
        rm -rf /var/www/html
        ln -s /phpstorm /var/www/html
fi


ln -s ${SCRIPT_PATH}/${SITE_NAME}.conf /etc/apache2/sites-available/${SITE_NAME}.conf
a2ensite $SITE_NAME

#fix apache startup warning "could not reliably determine the server's..." fqdn
ln -s ${SCRIPT_PATH}/servername.conf /etc/apache2/conf-available/servername.conf
a2enconf servername

#INSTALL phpMyAdmin
${SCRIPT_PATH}/phpmyadmin.sh

systemctl restart apache2

#ln -s /vagrant/bash_alias.sh /etc/profile.d/bash_alias.sh

${SCRIPT_PATH}/db.sh
#${SCRIPT_PATH}/db_load.sh


#aws credentials and config files
#manually fill in actual credentials
AWS_BASE='/.aws'
AWS_CRED=$AWS_BASE'/credentials'
AWS_CONFIG=$AWS_BASE'/config'

mkdir /.aws
echo 'aws_access_key_id=' > $AWS_CRED
echo 'aws_secret_access_key=' >> $AWS_CRED
echo '# error "No credentials present in INI profile" can be just a misspelling of either setting' >> $AWS_CRED
echo '# can use "role_arn" setting - see aws CredentialProvider.php public static function ini lambda' >> $AWS_CRED

echo '[default]' > $AWS_CONFIG
echo 'region=us-west-1' >> $AWS_CONFIG
echo 'output=json' >> $AWS_CONFIG
