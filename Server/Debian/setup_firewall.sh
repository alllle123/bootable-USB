#!/bin/bash

apt-get install firewalld

firewall-cmd --set-default-zone=dmz
firewall-cmd --zone=dmz --add-service=http --permanent
firewall-cmd --zone=dmz --add-service=https --permanent
firewall-cmd --zone=dmz --add-port=5666 --permanent
firewall-cmd --reload
