#!/bin/bash

apt-get install mariadb-client mariadb-server -y
mysql_secure_installation
apt-get install php7.0 php7.0-mysql -y
apt-get install apache2 apache2-mod-php7.0


apt-get install mcrypt -y

/etc/init.d/apache2 stop
/etc/init.d/apache2 start

apt-get install phpmyadmin -y


perl -pi -e 'BEGIN{$/=undef} s/(www>.*\n.*\n.*AllowOverride )None/$1All/g' /etc/apache2/apache2.conf
a2enmod rewrite
