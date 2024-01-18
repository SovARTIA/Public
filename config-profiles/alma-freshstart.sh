#!/usr/bin/env bash

set -x

######### THIS SCRIPT WILL UPDATE AND UPGRADE THE SYSTEM THEN INSTALL DOCKER + PORTAINER AND RESTART THE SYSTEM #####

echo \
"fastestmirror=True
max_parallel_downloads=20
defaultyes=True
colors=always" >> /etc/dnf/dnf.conf

dnf update -y --skip-broken --best

dnf clean all

dnf autoremove -y

#### Enable Cockpit 

systemctl enable --now cockpit.socket

systemctl start cockpit

systemctl reboot