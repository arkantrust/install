#!/bin/sh
#
# This script is used for installing tailscale, docker, snap and microk8s in some linux mint machines.
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/arkantrust/install/main/docker.sh)"

# ------------------ functions ------------------

# File to modify
PROFILE_FILE="$HOME/.profile"

# Function to add alias if not already present
add_alias() {
  local alias_command="$1"
  if ! grep -Fxq "$alias_command" "$PROFILE_FILE"; then
    echo "$alias_command" >> "$PROFILE_FILE"
    echo "Added: $alias_command"
  else
    echo "Alias already exists: $alias_command"
  fi
}

# ------------------ update and upgrade the system ------------------
sudo apt update

sudo apt upgrade -y

# ------------------ install docker ------------------

# uninstall all docker packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; \
  do sudo apt-get remove $pkg; done
  
# update
sudo apt update

# add Docker's official GPG key
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# add the repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu jammy stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

# install necessary packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# test installation
sudo docker -v

# ------------------ snap ------------------

sudo mv /etc/apt/preferences.d/nosnap.pref ~/Documents/nosnap.backup

sudo apt update

sudo apt install snapd

snap version


# ------------------ microk8s ------------------

sudo snap install microk8s --classic

sudo microk8s status --wait-ready

# ------------------ aliases ------------------

DOCKER_ALIAS="alias docker='sudo docker'"
MICROK8S_ALIAS="alias microk8s='sudo microk8s'"

# Add the aliases
add_alias "$DOCKER_ALIAS"
add_alias "$MICROK8S_ALIAS"

# Reload .profile to apply changes
source "$PROFILE_FILE"
echo "Aliases applied."
