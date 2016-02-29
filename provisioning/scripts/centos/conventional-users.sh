#!/usr/bin/env bash -eux

# Create group and user for 'terraform' conventional built-in account
sudo useradd -m -r -u 901 -G wheel -s /bin/bash -c "Built in privileged user to provide consistent access for provisioning" terraform

sudo ls /home

# Setup authorized_keys directory for 'terraform' conventional built-in account
sudo mkdir -p /home/terraform/.ssh

sudo ls -a /home/terraform/
sudo ls -a /tmp

# Copy authorized_keys for 'terraform' conventional built-in account
sudo cp /tmp/authorized_keys /home/terraform/.ssh/authorized_keys

sudo ls -la /home/terraform/.ssh

# Secure authorized_keys for 'terraform' conventional built-in account
sudo chmod 600 /home/terraform/.ssh/authorized_keys
sudo chmod 700 /home/terraform/.ssh
sudo chown -R terraform /home/terraform/.ssh
