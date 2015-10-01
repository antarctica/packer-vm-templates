#!/bin/bash -eux

echo "# Allow SSH agent to be used with Sudo for checking out from Git repositories" >> /etc/sudoers.d/ssh_auth_sock
echo ' Defaults   env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers.d/ssh_auth_sock

