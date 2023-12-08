#!/bin/sh

# TODO(spencer) figure the template out
export HOSTNAME=debian-template
export DOMAIN=crooked-stage.tcos.us
export ROOT_PASSWORD=n0passw0rd
export USER_NAME=spencer
export USER_PASSWORD=spencer

python -m http.server 
