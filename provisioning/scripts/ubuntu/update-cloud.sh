#!/usr/bin/env bash -eux

# Prepare for updating (this is needed to workaround Grub being obnoxious)
unset UCF_FORCE_CONFFOLD;
export UCF_FORCE_CONFFNEW=YES;
export DEBIAN_FRONTEND=noninteractive;
ucf --purge /boot/grub/menu.lst;

# Update the package list
apt-get update;

# Upgrade all installed packages
apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade;
