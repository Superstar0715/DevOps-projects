#!/bin/bash 

sudo yum update -y
sudo amazon-linux-extras install -y nginx1


ln /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

sudo systemctl enable nginx
sudo systemctl start nginx
