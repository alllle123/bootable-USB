#/bin/bash

site=$1

mkdir /var/www/$site/public_html -p
chown www-data:www-data /var/www/$site -R

echo "
<VirtualHost *:80>
        ServerAdmin admin@example.com
        ServerName $site
        ServerAlias www.$site
        DocumentRoot /var/www/$site/public_html
        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/$site.conf

a2ensite $site.conf
systemctl reload apache2
