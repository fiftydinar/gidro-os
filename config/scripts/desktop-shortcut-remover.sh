#!/usr/bin/env bash

set -euo pipefail

cd /usr/share/applications
echo 'Hidden=true' >> com.gerbilsoft.rom-properties.rp-config.desktop
