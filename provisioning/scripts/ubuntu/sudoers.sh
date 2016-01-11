#!/usr/bin/env bash -eux

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
sed -i -e '/Defaults\s\+exempt_group/a Defaults\tenv_keep += "SSH_AUTH_SOCK"' /etc/sudoers
