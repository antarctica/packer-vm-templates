#!/bin/sh -eux
# This script is only needed for cloud images as on desktops the kick-start process will configure the firewall

# Ensure firewall exists
sudo yum -y update;
sudo yum -y install firewalld;

# Start, but don't enable the firewall
sudo systemctl start firewalld.service;

# Allow SSH traffic for remote management
sudo firewall-cmd --zone=public --permanent --add-service=ssh;

# Update firewall configuration
sudo firewall-cmd --reload;

# Enable firewall to start on system startup
sudo systemctl enable firewalld;
