#!/bin/bash

#xdebug.sh
#change path to xdebug.so to current PHP extension dir
#imports SCRIPT_PATH

#PHP 7.0: zend_extension="/usr/lib/php/20151012/xdebug.so"
#PHP 7.2: zend_extension="/usr/lib/php/20170718/xdebug.so"
#PHP 7.4: zend_extension="/usr/lib/php/2019....?

PHP_EXT_DIR=$(php-config --extension-dir)
#PHP_API_NUM=$(php -i 2> /dev/null | grep 'PHP API' | sed -e 's/PHP API => //')
PHP_VER=$(php-config --version | egrep -o '^[0-9]*\.[0-9]')
PHP_MODS="/etc/php/$PHP_VER/mods-available"

if [ -z $SCRIPT_PATH ]; then
	cd ..
	#SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
	#SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
	SCRIPT_PATH=$(pwd)
	cd -
fi

XDEBUG_INI=$SCRIPT_PATH/config/xdebug.ini
#XDEBUG_INI=$(pwd)/xdebug.ini

#cp $XDEBUG_INI $XDEBUG_INI.old


#pecl not working on ubuntu 20
#should be able to install from ondrej repo
#pecl install xdebug

apt install -y php$PHP_VER-xdebug

#edit xdebug.ini with correct paths to xdebug.so, remote log, and profiler output dir
#sed -i 's~zend_extension="/usr/lib/php/20151012/xdebug.so"~zend_extension="'"$PHP_EXT_DIR"'"~' $XDEBUG_INI
sed -i 's~^zend_extension=.*~zend_extension="'"$PHP_EXT_DIR"'/xdebug.so"~' $XDEBUG_INI
sed -i 's~^xdebug.remote_log=.*~xdebug.remote_log="'"$SCRIPT_PATH"'/xdebug/remote_log.txt"~' $XDEBUG_INI
sed -i 's~^xdebug.profiler_output_dir=.*~xdebug.profiler_output_dir="'"$SCRIPT_PATH"'/xdebug/profiler/"~' $XDEBUG_INI



#replace existing xdebug.ini with mine
rm $PHP_MODS/xdebug.ini 2> /dev/null
ln -s $SCRIPT_PATH/config/xdebug.ini $PHP_MODS/xdebug.ini

#enable xdebug
phpenmod -v $PHP_VER xdebug
