#!/bin/bash

$user_name=$1

# /etc/vsftpd/vconf/$user_name
echo 'dirlist_enable=YES
download_enable=YES
local_root=/var/www/html
write_enable=YES' > /etc/vsftpd/vconf/$user_name
 
echo '$user_name' | tee /etc/vsftpd/password{,-nocrypt} > /dev/null
 
myval=$(openssl rand -base64 6)
echo $myval >> /etc/vsftpd/password-nocrypt
echo $(openssl passwd -crypt $myval) >> /etc/vsftpd/password
 
# /etc/vsftpd/password.db
db_load -T -t hash -f /etc/vsftpd/password /etc/vsftpd/password.db
