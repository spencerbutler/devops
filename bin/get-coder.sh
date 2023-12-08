#!/bin/sh

export CODER_DATA=$HOME/.config/coderv2-docker
export DOCKER_GROUP=$(getent group docker | cut -d: -f3)
mkdir -p $CODER_DATA
docker run --rm -it \
  -v $CODER_DATA:/home/coder/.config \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add $DOCKER_GROUP \
  ghcr.io/coder/coder:latest

