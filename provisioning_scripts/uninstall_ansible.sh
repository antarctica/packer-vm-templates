#!/bin/sh
set -ex

# Uninstall Ansible and dependencies
yes | pip uninstall ansible
yes | pip uninstall PyYAML
yes | pip uninstall jinja2
yes | pip uninstall paramiko
yes | pip uninstall MarkupSafe  # installed as a dependency
yes | pip uninstall ecdsa  # installed as a dependency

apt-get -y --purge remove python-pip
apt-get -y --purge remove python-dev
