#!/bin/bash 

sudo yum update -y
sudo amazon-linux-extras install -y nginx1.12


#ln /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

sudo systemctl start nginx
