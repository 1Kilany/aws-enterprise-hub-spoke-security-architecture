#!/bin/bash

yum update -y

yum install httpd -y

systemctl enable httpd
systemctl start httpd

echo "Hello from $(hostname)" > /var/www/html/index.html
