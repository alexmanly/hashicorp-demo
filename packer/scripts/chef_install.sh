#!/bin/bash

echo "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y unzip wget curl

echo "Installing Chef..."
wget https://packages.chef.io/stable/ubuntu/12.04/chef_12.14.89-1_amd64.deb -P /tmp
sudo apt-get install /tmp/chef_12.14.89-1_amd64.deb
rm -f /tmp/chef_12.14.89-1_amd64.deb
