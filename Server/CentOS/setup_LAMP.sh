#!/bin/bash

yum update
yum dist-upgrade -y

yum install apache2 -y
mysql_secure_installation
yum install php5 php-pear php5-mysql

yum install mcrypt

/etc/init.d/httpd stop
/etc/init.d/httpd start

yum install phpmyadmin

mkdir /var/www/public_html
ln -s /usr/share/phpmyadmin /var/www/public_html/phpmyadmin
chown apache:apache /var/www -R

perl -pi -e 'BEGIN{$/=undef} s/(www>.*\n.*\n.*AllowOverride )None/$1All/g' /etc/httpd/httpd.conf
