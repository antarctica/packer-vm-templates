#!/bin/sh
set -ex

# Update system
apt-get -y update

# Install Ansible dependencies
apt-get install -y git python-pip python-dev make fakeroot
yes | pip install PyYAML jinja2 paramiko httplib2

# Install Ansible
git clone git://github.com/ansible/ansible.git /home/vagrant/ansible_installer
cd /home/vagrant/ansible_installer
make install
rm -rf /home/vagrant/ansible_installer

# Create a directory for Ansible's files
mkdir -p /tmp/packer-provisioner-ansible-local/files
chmod 777 -R  /tmp/packer-provisioner-ansible-local