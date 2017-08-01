# install fail2ban
sudo apt-get install fail2ban


# setup firewall rules with iptables to block all traffic except on ports 80 and 22

iptables --policy INPUT DROP
iptables -A INPUT -p tcp -m tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save rules to file
iptables-save > /etc/iptables.rules



# setup the file /etc/network/interfaces to create static ip 
# and load firewall rules on startup
# replace eth0 and eth1 with the corresponding names on the machine
# Nameservers are always 83.168.226.226 83.168.225.225
auto eth0
iface eth0 inet static
  address 217.70.36.46
  netmask 255.255.255.0
  dns-nameservers 83.168.226.226 83.168.225.225
  pre-up iptables-restore < /etc/iptables.rules

auto eth1
iface eth1 inet dhcp


# check that the settings in /etc/fail2ban/jail.conf are correct
