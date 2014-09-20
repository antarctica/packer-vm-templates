#!/bin/sh
set -ex

# Final package cleaning
apt-get autoremove -y --purge
apt-get -y clean
find /var/lib/apt -type f | xargs rm -f

# Remove linux headers
dpkg -l 'linux-*' |grep ^ii
uname -a
apt-get remove -y --purge $(dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d')
apt-get remove -y linux-source*
dpkg -l 'linux-*' |grep ^ii

# Empty log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Reset command histories - do this last
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history
