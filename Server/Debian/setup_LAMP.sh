#!/bin/bash

apt-get update
apt-get dist-upgrade -y

apt-get install apache2 -y
mysql_secure_installation
apt-get install php5 php-pear php5-mysql

apt-get install mcrypt

/etc/init.d/apache2 stop
/etc/init.d/apache2 start

apt-get install phpmyadmin

mkdir /var/www/public_html
ln -s /usr/share/phpmyadmin /var/www/public_html/phpmyadmin
chown www-data:www-data /var/www -R

perl -pi -e 'BEGIN{$/=undef} s/(www>.*\n.*\n.*AllowOverride )None/$1All/g' /etc/apache2/apache2.conf
