#!/bin/sh
# Clear machine-id
# https://manpages.ubuntu.com/manpages/bionic/man5/machine-id.5.html

if [ -f /etc/machine-id ]; then
    cat /dev/null > /etc/machine-id
fi

if [ -f /var/lib/dbus/machine-id ]; then
    rm -f /var/lib/dbus/machine-id
fi

# Linking /var/lib/dbus/machine-id to /etc/machine-id means it will not 
# need to be regenerated later and it will always be the same.
ln -s /etc/machine-id /var/lib/dbus/machine-id
