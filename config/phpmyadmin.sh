#!/bin/bash

PASS=vagrant
export DEBIAN_FRONTEND=noninteractive

# answer the questions
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-pass password $PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/setup-password password $PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/admin-pass password $PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"


debconf-set-selections <<< "phpmyadmin/dbconfig-reinstall boolean true"

debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get install -y phpmyadmin

ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
