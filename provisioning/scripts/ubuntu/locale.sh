#!/bin/sh -eux
# This script is only needed for cloud images as on desktops the pre-seed process will configure the firewall

# Generate locale
sudo locale-gen "en_GB.UTF-8";
sudo dpkg-reconfigure locales;

# Set locale
sudo update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8;
