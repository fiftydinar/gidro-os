#!/usr/bin/env bash
set -oue pipefail

systemctl enable com.system76.PowerDaemon.service 
systemctl enable system76-power-wake
systemctl mask power-profiles-daemon.service
