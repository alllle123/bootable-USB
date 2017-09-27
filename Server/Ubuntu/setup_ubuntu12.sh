apt-get update -y
apt-get dist-upgrade -y

iptables -A INPUT -p tcp -s 83.168.200.20 --dport 5666 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP

sh -c "iptables-save > /etc/iptables.rules"

echo "  pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces

apt-get install fail2ban -y

userdel online
useradd onlinegroup_admin
usermod -Ga sudo onlinegroup_admin
mkdir /home/onlinegroup_admin
mkdir /home/onlinegroup_admin/.ssh
mkdir /home/onlinegroup_admin/.vim
rm -rf /home/online
mkdir /root/.vim
wget https://raw.githubusercontent.com/Kabix1/bootable-USB/master/Server/configs/sensible.vim
cp sensible.vim /home/onlinegroup_admin/.vim/
cp sensible.vim .vim/
echo "source ~/.vim/sensible.vim" > .vimrc
cp .vimrc /home/onlinegroup_admin/
chown onlinegroup_admin:onlinegroup_admin /home/onlinegroup_admin/ -R
