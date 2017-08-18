#!/bin/bash

yum install httpd -y
yum install mariadb-server mariadb -y
systemctl start mariadb
mysql_secure_installation
sed -i 's-\[mysqld\]-\[mysqld\]\ntmpdir=/tmp-' /etc/my.cnf

yum install php5 php-pear php5-mysql -y

yum install mcrypt -y

/etc/init.d/httpd stop
/etc/init.d/httpd start

yum install phpmyadmin -y

mkdir /var/www/public_html
ln -s /usr/share/phpmyadmin /var/www/public_html/phpmyadmin
chown apache:apache /var/www -R

perl -pi -e 'BEGIN{$/=undef} s/(www>.*\n.*\n.*AllowOverride )None/$1All/g' /etc/httpd/conf/httpd.conf

systemctl enable mariadb
systemctl enable httpd
