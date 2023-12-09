#!/bin/sh
# Spencer Butler <dev@tcos.us>
# bootstrap a fresh debian base image

[ ! $(id -u) = 0 ] && { echo "Use root."; exit 1; }

# Disable suggests and recommends
cat > /etc/apt/apt.conf.d/01norecommend << EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

packages="
qemu-guest-agent
tmux
npm
jq
ipython3
ncat
git
"

apt-get update
apt-get install -y $packages
apt-get clean

# make nvim vim
# TODO(spencer) find a better way
#update-alternatives --install $(which vim) vim $(which nvim) 99

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
