#!/usr/bin/env sh

 Copyright 2024 Sovereignty A.R.T.I.A.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description: Update system, install cockpit and set up for chibisafe

## update DNF with more optimized settings
echo \
"fastestmirror=True
max_parallel_downloads=20
defaultyes=True
colors=always" >> /etc/dnf/dnf.conf

# update the system
dnf update -y --skip-broken --best

# Install Cockpit
dnf install cockpit cockpit-doc cockpit-packagekit cockpit-podman cockpit-storaged epel-release -y

# enable extended repo
crb enable

dnf install google-authenticator -y

# clean any cached files
dnf clean all

dnf autoremove -y

## Enable Cockpit | more information on cockpit -----------> https://cockpit-project.org/documentation

systemctl enable --now cockpit.socket

systemctl start cockpit

## Create folders and set permissions for app

mkdir -m 755 /srv/uploads && chown tom.tom /srv/uploads

mkdir -p -m 754 /home/tom/chibisafe/database && chown -R /home/tom/chibisafe

mkdir -m 754 /var/log/chibisafe && chown tom.tom /var/log/chibisafe

useradd -m -s /usr/bin/bash -c "default admin user" -G wheel tom