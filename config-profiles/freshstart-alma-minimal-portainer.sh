#!/usr/bin/env bash

# Copyright 2024 Sovereignty A.R.T.I.A.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description: Updates the system and installs Portainer on AlmaLinux

# Enable error handling
set -e

# Redirect standard error to a file
exec 2> error.log

# Function to handle errors
handle_error() {
    echo "Error on line $1: '$2'" >> error.log
}

# Trap errors with the error handler
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

## update DNF with more optimized settings
echo \
"fastestmirror=True
max_parallel_downloads=20
defaultyes=True
colors=always" >> /etc/dnf/dnf.conf

# update the system
dnf update -y --skip-broken --best

# add Docker repo
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# install Docker
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start docker
systemctl enable --now docker

systemctl start docker

# install Portainer compose file
mkdir /root/portainer

echo \
"---
version: '3'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /opt/portainer/portainer-data:/data
    ports:
      - 9000:9000
..." > /root/portainer/compose.yml

# start Portainer
cd /root/portainer && docker compose up -d

# remove unneccessary files after install
dnf clean all

dnf autoremove -y

# start privileged ports at 80
sudo sysctl net.ipv4.ip_unprivileged_port_start=80

# restart the system
systemctl reboot