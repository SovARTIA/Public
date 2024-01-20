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

# Description: AlmaLinux fresh install script - install google authenticator, 
#              update system and start Cockpit.

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

## THIS SCRIPT WILL UPDATE AND UPGRADE THE SYSTEM THEN RESTART THE SYSTEM #####

echo \
"fastestmirror=True
max_parallel_downloads=20
defaultyes=True
colors=always" >> /etc/dnf/dnf.conf

dnf update -y --skip-broken --best

dnf install epel-release -y

crb enable

dnf install google-authenticator -y

dnf clean all

dnf autoremove -y

## Enable Cockpit | more information on cockpit -----------> https://cockpit-project.org/documentation

systemctl enable --now cockpit.socket

systemctl start cockpit

systemctl reboot

#/#/EOF\#\#