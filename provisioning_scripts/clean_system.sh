#!/bin/sh
set -ex

# Final package cleaning
apt-get -y clean
apt-get autoremove -y --purge
find /var/lib/apt -type f | xargs rm -f

# Remove linux headers
rm -rf /usr/src/linux-headers*

# Empty log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Reset command histories - do this last
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history