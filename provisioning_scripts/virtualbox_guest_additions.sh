#!/bin/sh
set -ex

# Installs virtualbox guest additions
# TODO: add proper banner

# TODO: Have a variable for selecting virtualbox guest additions version

# Install prerequisites 
apt-get update -y
apt-get install -y linux-headers-$(uname -r) build-essential dkms
mount -o loop VBoxGuestAdditions.iso /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run
umount /media/cdrom
ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions