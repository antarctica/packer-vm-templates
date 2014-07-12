#!/bin/sh
set -ex

echo 'vagrant ALL=NOPASSWD:ALL' > /tmp/vagrant
chmod 440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/