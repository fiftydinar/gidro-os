#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

systemctl enable com.system76.Scheduler.service
mkdir /usr/etc/system76-scheduler
wget https://raw.githubusercontent.com/pop-os/system76-scheduler/5c20d3dbbc4d0f2a324ecd536adb9131dfcaeaf0/data/config.kdl -O /usr/etc/system76-scheduler/config.kdl
cd /usr/etc/system76-scheduler/
sed -i 's/cfs-profiles enable=true/cfs-profiles enable=false/' config.kdl
