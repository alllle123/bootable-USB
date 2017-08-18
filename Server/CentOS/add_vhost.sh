#!/bin/bash

sed -i 's/<website_tld>/kvalitetsflytt.se/g' Virtual_Host
sed -i 's/<website>/kvalitetsflytt/g' Virtual_Host
sed -i 's/<email>/juha@jupeko.com/g' Virtual_Host

cat Virtual_Host >> /etc/httpd/conf/httpd.conf
