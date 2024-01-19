#!/usr/bin/env bash

# Author: Sovereignty A.R.T.I.A.
# Description: AlmaLinux fresh install script - update and start Cockpit.
# License: MPL, v2.0 | (https://github.com/SovARTIA/Public/blob/a2d5042a7eb7b3e5302b51356f9e4d1fcec14459/LICENSES/MPL.md)

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

######### THIS SCRIPT WILL UPDATE AND UPGRADE THE SYSTEM THEN RESTART THE SYSTEM #####

echo \
"fastestmirror=True
max_parallel_downloads=20
defaultyes=True
colors=always" >> /etc/dnf/dnf.conf

dnf update -y --skip-broken --best

dnf clean all

dnf autoremove -y

#### Enable Cockpit | more information on cockpit -----------> 

systemctl enable --now cockpit.socket

systemctl start cockpit

systemctl reboot

#/#/EOF\#\#