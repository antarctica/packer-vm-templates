#!/usr/bin/env bash -eux

# Ensure firewall exists
apt-get install ufw;

# Allow SSH traffic for remote management
ufw allow OpenSSH;

# Start and enable firewall
ufw --force enable;
