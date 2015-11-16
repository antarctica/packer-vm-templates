#!/bin/bash -eux

# Allow passwordless sudo for wheel (sudo) group
echo "# Allow passwordless sudo for members of the wheel group" >> /etc/sudoers.d/wheel_nopasswd
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel_nopasswd

# Add additional sudoers file to allow agent forwarding in sudo
echo "# Allow SSH agent to be used with Sudo for checking out from Git repositories" >> /etc/sudoers.d/ssh_auth_sock
echo 'Defaults   env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers.d/ssh_auth_sock
