apt-get update -y
apt-get dist-upgrade -y
apt-get install python-pip -y

apt-get install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

apt-get install firewalld -y
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=dmz
firewall-cmd --zone=dmz --add-service=http --permanent
firewall-cmd --zone=dmz --add-service=https --permanent
firewall-cmd --reload

usermod -Ga sudo onlinegroup_admin
mkdir /home/onlinegroup_admin/.ssh
mkdir /home/onlinegroup_admin/.vim
mkdir .vim
wget https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/configs/sensible.vim
cp sensible.vim /home/onlinegroup_admin/.vim/
cp sensible.vim .vim/
echo "source ~/.vim/sensible.vim" > .vimrc
cp .vimrc /home/onlinegroup_admin/
chown onlinegroup_admin:onlinegroup_admin /home/onlinegroup_admin/ -R

wget https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/All/remake_fdisk.sh
wget https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/All/resize_after_reboot.sh
