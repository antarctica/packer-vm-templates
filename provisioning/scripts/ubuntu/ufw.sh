#!/usr/bin/env bash -eux

# Ensure firewall exists
sudo apt-get install ufw;

# Allow SSH traffic for remote management
sudo ufw allow OpenSSH;

# Start and enable firewall
sudo ufw --force enable;
