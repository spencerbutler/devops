#!/bin/sh
# simple bootstrap, from the template

sudo apk update
sudo apk add qemu-guest-agent curl vim tmux jq bash git \
    ipython sudo nodejs bash-completion docker docker-bash-completion \
    docker-cli-compose cloud-utils-growpart e2fsprogs-extra coreutils \
    findutils
sudo rc-update add qemu-guest-agent
sudo rc-update add docker
