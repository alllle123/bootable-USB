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
echo n
echo p
echo 3
echo  
echo  
echo t
echo  
echo 8e
echo w
) | fdisk
pvcreate /dev/sda3
vgextend volgrp /dev/sda3
lvextend /dev/volgrp/root /dev/sda3
resize2fs /dev/volgrp/root
