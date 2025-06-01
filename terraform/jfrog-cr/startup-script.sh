#!/bin/bash

###############################
#         CONFIG VARS         #
###############################

jfrog_config_folder="/opt/jfrog"
fstab_path="/etc/fstab"

###############################
#      DISK CONFIGURATION     #
###############################

# Create the mount point
sudo mkdir -p "$jfrog_config_folder"

# Format the disk with ext4 if it is not ext4
FILESYSTEM_TYPE=$(sudo blkid -o value -s TYPE /dev/sdb)
if [ "$FILESYSTEM_TYPE" != "ext4" ]; then
  sudo mkfs.ext4 /dev/sdb
fi

# Get the UUID of the disk
UUID=$(sudo blkid -s UUID -o value /dev/sdb)
disk_config_fstab="UUID=$UUID $jfrog_config_folder ext4 defaults 0 0"

# Add or update the fstab entry
if grep -q "$jfrog_config_folder" "$fstab_path"; then
  sudo sed -i "\|$jfrog_config_folder|c\\$disk_config_fstab" "$fstab_path"
else
  echo "$disk_config_fstab" | sudo tee -a "$fstab_path" > /dev/null
fi

# Mount the disk
sudo mount -a

###############################
#     JFROG INSTALLATION      #
###############################

# Install Docker and dependencies
sudo apt update
sudo apt-get install ca-certificates curl nginx make -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER

# Prepare JFrog configuration folder
export JFROG_HOME=/opt/jfrog
sudo mkdir -p $JFROG_HOME/artifactory/var/etc/
cd $JFROG_HOME/artifactory/var/etc/
sudo touch ./system.yaml
sudo chown -R 1030:1030 $JFROG_HOME

# Run JFrog container registry
docker run --name jcr \
  -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory \
  -d -p 8081:8081 -p 8082:8082 \
  releases-docker.jfrog.io/jfrog/artifactory-jcr:7.77.5
