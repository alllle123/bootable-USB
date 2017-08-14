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
echo p
echo 3
echo  
echo  
echo t
echo  
echo 8e
echo w
) | fdisk /dev/sda
pvcreate /dev/sda2
vgextend volgrp /dev/sda2
lvextend /dev/volgrp/root /dev/sda2
resize2fs /dev/volgrp/root
