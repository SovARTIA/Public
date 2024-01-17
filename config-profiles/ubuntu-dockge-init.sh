#!/usr/bin/env bash

#/!*!*---->This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.<----*!*!\

################### LANd DOCKGE INSTALL SCRIPT ####################################

######
#Set timezone to "America/Anchorage"
timedatectl set-timezone America/Anchorage

#This phase will install the Volian Repos for Nala install and update the system packages
echo "deb http://deb.volian.org/volian/ scar main" > /etc/apt/sources.list.d/volian-archive-scar-unstable.list

wget -qO - https://deb.volian.org/volian/scar.key > /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg

apt update 

DEBIAN_FRONTEND=noninteractive apt upgrade -y

DEBIAN_FRONTEND=noninteractive apt install nala ca-certificates curl gnupg -y
#This phase will install docker using the official docker repos

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update

DEBIAN_FRONTEND=noninteractive apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

systemctl start docker

#This phase will install and start Dockge docker management
mkdir /root/dockge

echo \
  "version: '3.8'
services:
  dockge:
    image: louislam/dockge:1
    restart: unless-stopped
    ports:
      # Host Port : Container Port
      - 5001:5001
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data

      # If you want to use private registries, you need to share the auth file with Dockge:
      # - /root/.docker/:/root/.docker

      # Stacks Directory
      # ⚠️ READ IT CAREFULLY. If you did it wrong, your data could end up writing into a WRONG PATH.
      # ⚠️ 1. FULL path only. No relative path (MUST)
      # ⚠️ 2. Left Stacks Path === Right Stacks Path (MUST)
      - /root/.stacks:/root/.stacks
    environment:
      # Tell Dockge where is your stacks directory
      - DOCKGE_STACKS_DIR=/root/.stacks/" > /root/dockge/compose.yml

cd /root/dockge && docker compose up -d
#This phase will reboot the system

systemctl reboot