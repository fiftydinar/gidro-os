#!/usr/bin/env bash

set -oue pipefail

cd /usr/share/applications
echo 'Hidden=true' >> com.gerbilsoft.rom-properties.rp-config.desktop
