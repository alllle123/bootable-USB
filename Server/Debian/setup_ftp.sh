#!/bin/bash
 
#------------------------------------------------------------------------------------
# Install vsFTPd
#------------------------------------------------------------------------------------
apt-get install -y db-util 
apt-get install -y vsftpd
systemctl enable vsftpd.service
mkdir -p /etc/vsftpd/vconf
 
#------------------------------------------------------------------------------------
# Configure vsFTPd data directory and user
#------------------------------------------------------------------------------------
 
useradd -s /sbin/nologin vsftpd
 
#------------------------------------------------------------------------------------
# Configure vsFTPd (/etc/vsftpd.conf)
#------------------------------------------------------------------------------------
 
cp /etc/vsftpd.conf{,.original}
 
sed -i "s/^.*anonymous_enable.*/anonymous_enable=NO/g" /etc/vsftpd.conf
sed -i "/^xferlog_std_format*a*/ s/^/#/" /etc/vsftpd.conf
sed -i "s/#idle_session_timeout=600/idle_session_timeout=900/" /etc/vsftpd.conf
sed -i "s/#nopriv_user=ftpsecure/nopriv_user=www-data/" /etc/vsftpd.conf
sed -i "/#chroot_list_enable=YES/i\chroot_local_user=YES" /etc/vsftpd.conf
sed -i 's/listen=NO/listen=YES/' /etc/vsftpd.conf
sed -i 's/listen_ipv6=YES/listen_ipv6=NO/' /etc/vsftpd.conf
 
# guest_username=www-data
guest_username=vsftpd
echo 'allow_writeable_chroot=YES
guest_enable=YES
local_root=/var/www/public_html
user_sub_token=$USER
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/vconf' >> /etc/vsftpd.conf
 
systemctl start vsftpd.service
 
#------------------------------------------------------------------------------------
# Configure pam (/etc/pam.d/vsftpd)
#------------------------------------------------------------------------------------
 
cp /etc/pam.d/vsftpd{,.original}
 
echo '#%PAM-1.0
auth required pam_userdb.so db=/etc/vsftpd/password crypt=crypt
account required pam_userdb.so db=/etc/vsftpd/password crypt=crypt
session required pam_loginuid.so' > /etc/pam.d/vsftpd
 
#------------------------------------------------------------------------------------
# Configure firewalld
#------------------------------------------------------------------------------------
 
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
 
#------------------------------------------------------------------------------------
# Configure selinux
#------------------------------------------------------------------------------------
 
