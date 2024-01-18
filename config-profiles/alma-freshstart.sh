#!/usr/bin/env bash

#/!*!*---->This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. © 2024 | Sovereignty ARTIA. If a copy of the MPL was not distributed with this file, You can obtain one at https://github.com/SovARTIA/Public/blob/a2d5042a7eb7b3e5302b51356f9e4d1fcec14459/LICENSES/MPL.md.<----*!*!\

#Set timezone to "America/Anchorage"
timedatectl set-timezone America/Anchorage #set to current timezone

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