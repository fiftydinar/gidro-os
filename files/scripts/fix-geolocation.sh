#!/usr/bin/env bash

set -euo pipefail

mkdir -p /etc/geoclue/conf.d/
echo "[wifi]
enable=true
url=https://api.beacondb.net/v1/geolocate" > /etc/geoclue/conf.d/99-beacondb.conf
