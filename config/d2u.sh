#!/bin/bash

if [ -d /vagrant/config ]
	then
	cd /vagrant/config
	find -type f -exec dos2unix "{}" \+
	cd -
fi

