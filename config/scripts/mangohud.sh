#!/usr/bin/env bash
set -oue pipefail

echo "MANGOHUD=1" >> /usr/etc/environment
echo "MANGOHUD_CONFIG=no_display" >> /usr/etc/environment
