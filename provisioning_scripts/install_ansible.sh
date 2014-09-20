#!/bin/sh
set -ex

# Update system
apt-get -y update

# Install Ansible dependencies
apt-get install -y git python python-pip python-dev

# Install ansible
yes | pip install ansible

# Create a directory for Ansible's files
mkdir -p /tmp/packer-provisioner-ansible-local/files
chmod 777 -R  /tmp/packer-provisioner-ansible-local
