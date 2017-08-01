#!/bin/bash
ssh root@$1 << EOF
  hostname $2
  yum update
  yum install perl
  yum install curl
  curl -o latest -L https://securedownloads.cpanel.net/latest
  nohup sh latest
  /usr/local/cpanel/cpkeyclt
EOF
