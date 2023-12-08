#!/bin/sh
# Spencer Butler <dev@tcos.us>
# bootstrap a fresh debian base image

[ ! $(id -u) = 0 ] && { echo "Use root."; exit 1; }

# Disable suggestiongs and recommends
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
