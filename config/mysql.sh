#!/bin/bash

#imports $SCRIPT_PATH and $SITE_NAME

#set -u
#set -x

apt-get install -y debconf

debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'

#installs mysql 8 in Ubuntu 20
apt-get install -y mysql-server

#have to use CP bc mysql refuses to boot up with symlinked config file
#ubuntu 16 uses my.cnf. 18 uses mysql.cnf
mv /etc/mysql/conf.d/mysql.cnf /etc/mysql/conf.d/mysql.cnf.orig
# 20220401 removing 'config' from path bc I think it's in $SCRIPT_PATH
#cp $SCRIPT_PATH/mysql/my.cnf /etc/mysql/conf.d/mysql.cnf
cp $SCRIPT_PATH/mysql/conf.d/my8.0.cnf /etc/mysql/conf.d/my.cnf
chmod 640 /etc/mysql/conf.d/mysql.cnf


#NOTE: even though default file name is "my5.6.cnf" mysql won't open
#cnf files with more than one dot! that's why I rename to "my56.cnf"
#cp $SCRIPT_PATH/config/mysql/conf.d/my5.6.cnf /etc/mysql/conf.d/my56.cnf
#chmod 640 /etc/mysql/conf.d/my5.6.cnf

#in Ubuntu 14, added php5-mysqlnd to solve mismatch between MySQL version and php-mysql version
#apt-get install php5-mysql


#UNCOMMENT THIS
#apt-get install -y php-mysql
#apt-get install -y mcrypt

service mysql restart


# Give apache access to mysql-files
chown mysql:www-data /var/lib/mysql-files
chmod 770 /var/lib/mysql-files
chmod g+s /var/lib/mysql-files

# doesn't work bc pass has to be set by interactive shell
# set login path as user "vagrant"
#sudo -i -u vagrant bash << EOF
#mysql-config-editor set --login-path=local --host=localhost --user=vagrant --password=vagrant
#EOF


bash $SCRIPT_PATH/config/db.sh
bash $SCRIPT_PATH/config/db_load.sh
