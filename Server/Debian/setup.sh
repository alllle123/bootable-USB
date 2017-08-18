nohup apt-get update -y

apt-get install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

atp-get install firewalld -y
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --set-default-zone=dmz
firewall-cmd --zone=dmz --add-service=http --permanent
firewall-cmd --zone=dmz --add-service=https --permanent
firewall-cmd --reload

userdel onlinegroup
adduser onlinegroup_admin
usermod -Ga sudo onlinegroup_admin
mkdir /home/onlinegroup_admin/.ssh
mkdir /home/onlinegroup_admin/.vim
mkdir .vim
cp sensible.vim /home/onlinegroup_admin/.vim/
cp sensbile.vim .vim/
echo "source ~/.vim/sensible.vim" > .vimrc
cp .vimrc /home/onlinegroup_admin/
chown onlinegroup_admin:onlinegroup_admin /home/onlinegroup_admin/ -R
