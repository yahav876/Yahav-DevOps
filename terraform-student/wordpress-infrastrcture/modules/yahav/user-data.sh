#!/bin/bash
yum update -y
yum install httpd -y
cd /var/www/html
echo "yahav wordpress" > index.html
chkconfig httpd on
service httpd startupdate -y