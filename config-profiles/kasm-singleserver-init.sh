#!/usr/bin/env bash

##################SCRIPT CONFIG################
#Set timezone to "America/Anchorage"
timedatectl set-timezone America/Anchorage

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

# Define a function that prints a message when the script exits
function on_exit {
  echo "AN ERROR HAS OCCURED DURING THE UPDATE AND INSTALL PROCESS OF KASM, PLEASE CHECK THE \"error.log\" file for details."
}

# Set a trap to call the function when the script exits
trap on_exit EXIT
##############################################
#This phase will install the Volian Repos for Nala install
echo "deb http://deb.volian.org/volian/ scar main" > /etc/apt/sources.list.d/volian-archive-scar-unstable.list

wget -qO - https://deb.volian.org/volian/scar.key > /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg

apt update

DEBIAN_FRONTEND=noninteractive apt upgrade -y

DEBIAN_FRONTEND=noninteractive apt install nala ca-certificates curl gnupg -y

#This phase will install docker using the official docker repos
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update

DEBIAN_FRONTEND=noninteractive apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# List of services to restart
services=("cron" "dbus" "irqbalance" "ModemManager" "multipathd" "networkd-dispatcher" "packagekit" "polkit" "rsyslog" "snapd" "ssh" "systemd-logind" "systemd-timesyncd" "systemd-udevd" "udisks2" "unattended-upgrades")

for service in "${services[@]}"
do
    echo "Restarting $service"
    sudo systemctl restart $service || true
    if [ $? -eq 0 ]; then
        echo "$service restarted successfully"
    else
        echo "Failed to restart $service"
    fi
done

systemctl start docker

#This phase will install kasm (single server by default)
cd /tmp

curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.14.0.3a7abb.tar.gz

tar -xf kasm_release_1.14.0.3a7abb.tar.gz

DEBIAN_FRONTEND=noninteractive bash kasm_release/install.sh --accept-eula --swap-size 4096
