#!/usr/bin/env bash -eux

# Ensures missing host keys will be regenerated on startup
cat <<EOF >/etc/rc.local;
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
test -f /etc/ssh/ssh_host_rsa_key || dpkg-reconfigure openssh-server
EOF
