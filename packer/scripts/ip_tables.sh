#!/usr/bin/env bash
set -e

sudo iptables -I INPUT -s 0/0 -p tcp --dport 8300 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8301 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8302 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8400 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8500 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 4648 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 4647 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 4646 -j ACCEPT

sudo iptables-save | sudo tee /etc/iptables.rules
