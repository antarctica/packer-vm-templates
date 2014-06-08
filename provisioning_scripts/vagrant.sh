#!/bin/sh
set -ex

# Configure system to be compatable with vagrant
# TODO: add proper banner

# Add vagrant insecure public key
mkdir /home/vagrant/.ssh
wget -qO- https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 400 /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/

# Configure passwordless sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/