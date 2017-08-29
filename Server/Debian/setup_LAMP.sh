#!/bin/bash

apt-get install apache2 -y
apt-get install mysql-server -y
mysql_secure_installation
apt-get install php5 php-pear php5-mysql -y

apt-get install mcrypt -y

/etc/init.d/apache2 stop
/etc/init.d/apache2 start

apt-get install phpmyadmin -y

mkdir /var/www/public_html
ln -s /usr/share/phpmyadmin /var/www/public_html/phpmyadmin
chown www-data:www-data /var/www -R

perl -pi -e 'BEGIN{$/=undef} s/(www>.*\n.*\n.*AllowOverride )None/$1All/g' /etc/apache2/apache2.conf
a2enmod rewrite
