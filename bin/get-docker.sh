#!/bin/sh
# Get official docker
# https://docs.docker.com/engine/install/debian/

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Add Docker's packages:
echo "Grabbing docker shit ..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add $USER to the docker group to avoid sudo:
DOCKER_GROUP=docker
sudo usermod -aG $DOCKER_GROUP $USER

# Switch to the new group (new shell)
echo "Entering a new shell with primary group $DOCKER_GROUP ..."
echo "You'll need to login again for this to take affect system wide."
echo
newgrp docker

# Fetch and run the Hellow World
echo "Running the hello world container as user: $USER group: $(id -g) (${DOCKER_GROUP})"
docker run hello-world
