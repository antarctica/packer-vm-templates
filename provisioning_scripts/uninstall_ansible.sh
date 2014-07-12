#!/bin/sh
set -ex

# Uninstall Ansible
# (There must be a better way of doing this as stuff will be missed)
rm /usr/local/bin/ansible
rm /usr/local/bin/ansible-galaxy
rm /usr/local/bin/ansible-playbook
rm /usr/local/bin/ansible-pull
rm /usr/local/bin/ansible-vault

# Uninstall Ansible dependencies

# (This is not as rigorous as it could be)
yes | pip uninstall PyYAML
yes | pip uninstall jinja2
yes | pip uninstall paramiko
yes | pip uninstall httplib2

apt-get -y --purge remove git
apt-get -y --purge remove python-pip
apt-get -y --purge remove python-dev
apt-get -y --purge remove make
apt-get -y --purge remove fakeroot