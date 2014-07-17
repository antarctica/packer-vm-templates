#!/bin/sh
set -ex

# Uninstall Ansible
# (There must be a better way of doing this as stuff will be missed)
rm /usr/local/bin/ansible
rm /usr/local/bin/ansible-galaxy
rm /usr/local/bin/ansible-playbook
rm /usr/local/bin/ansible-pull
rm /usr/local/bin/ansible-vault
rm -rf /usr/share/ansible/

# Uninstall Ansible dependencies
yes | pip uninstall PyYAML
yes | pip uninstall jinja2
yes | pip uninstall paramiko
yes | pip uninstall httplib2
yes | pip uninstall MarkupSafe  # installed as a dependency
yes | pip uninstall ecdsa  # installed as a dependency

apt-get -y --purge remove git
apt-get -y --purge remove python-pip
apt-get -y --purge remove python-dev
apt-get -y --purge remove fakeroot
# Make should also be uninstalled but its part of build-essential
# Build-essential is left behind to rebuild guest additions later