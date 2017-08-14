nohup apt-get update -y

apt-get install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

mkdir /etc/firewall
cp enable.sh /etc/firewall/
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
