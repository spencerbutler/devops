#!/bin/sh
# https://github.com/microsoft/vscode-remote-release/issues/6347

sudo apk update
sudo apk add gcompat libstdc++ curl
sudo sed -i -e 's/^AllowTcpForwarding no/AllowTcpForwarding yes/' sshd_config
sudo service sshd restart