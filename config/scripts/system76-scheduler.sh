#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

mkdir -p /usr/etc/system76-scheduler
wget https://raw.githubusercontent.com/ublue-os/bazzite/main/system_files/desktop/shared/usr/etc/system76-scheduler/config.kdl -O /usr/etc/system76-scheduler/config.kdl
