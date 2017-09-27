#!/bin/bash

apt-get install mailutils

firewall-cmd --add-service=smtp --permanent
firewall-cmd --reload
