#!/usr/bin/env bash -eux

ubuntu_version="`lsb_release -r | awk '{print $2}'`";
ubuntu_major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

# Update the package list
apt-get update;

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y upgrade linux-generic;

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-`uname -r`;

# update package index on boot
cat <<EOF >/etc/init/refresh-apt.conf;
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF
