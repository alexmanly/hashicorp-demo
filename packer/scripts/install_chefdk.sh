#!/bin/bash
#sudo yum update -y
sudo yum install wget -y
wget https://packages.chef.io/stable/el/7/chefdk-0.14.25-1.el7.x86_64.rpm -P /tmp
sudo rpm -ivh /tmp/chefdk-0.14.25-1.el7.x86_64.rpm
