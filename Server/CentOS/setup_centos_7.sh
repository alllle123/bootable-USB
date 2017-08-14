nohup yum update -y
yum install net-tools -y
systemctl disable NetworkManager.service
systemctl stop NetworkManager.service
service network restart
firewall-cmd --set-default-zone=dmz
firewall-cmd --zone=dmz --add-service=http --permanent
firewall-cmd --zone=dmz --add-service=https --permanent
firewall-cmd --reload

(
echo d
echo 
echo n
echo 
echo 
echo  
echo  
echo t
echo  
echo 8e
echo w
) | fdisk /dev/sda
reboot
pvresize /dev/sda2
lvextend -l +100%FREE /dev/volgrp/root
resize2fs /dev/volgrp/root
