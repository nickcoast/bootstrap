#!/bin/bash

MYSQL=`which mysql`
USER=vagrant
PASS=vagrant
DB=iroko

#TODO - be more specific in *.* priveleges. Which DBs and tables specifically?
#TODO - perhaps remove some DELETE priveleges on main app data db.

Q0="CREATE DATABASE IF NOT EXISTS ${DB};"
Q1="CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${PASS}';"
Q2="GRANT SELECT, FILE ON *.* TO '${USER}'@'localhost';"
#20220402 Need to test to see if Q3 works. Note double-slash inside ""
#should turn into single \ in SQL query
Q3="GRANT ALL PRIVILEGES ON `${DB}\\_%`.* TO '${USER}'@'localhost';"
echo "Wildcard query should be single-slash "$Q3

Q4="FLUSH PRIVILEGES;"
SQL="${Q0}${Q1}${Q2}${Q3}${Q4}"

$MYSQL -u root -p${PASS} -e "$SQL"


#Also, phpMyAdmin runs this query right after granting global privileges like FILE. Do I need this? Seems like it would be default values
#ALTER USER 'test'@'%' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
#Also also, above Q1 uses MySQL authentication. Alternative using caching_sha2_password below:
#CREATE USER 'test'@'%' IDENTIFIED WITH caching_sha2_password BY '***';
