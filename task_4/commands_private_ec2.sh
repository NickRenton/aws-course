#! /bin/bash

sudo su
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
# shellcheck disable=SC2164
cd /var/www/html
echo "<html><h1> This is private shinobi from Sunagakure</h1></html>" > index.html