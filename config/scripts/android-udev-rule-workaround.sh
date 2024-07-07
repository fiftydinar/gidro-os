#!/usr/bin/env bash

set -euo pipefail

# Workaround for updating android udev rule until it gets properly updated by Ublue
wget https://raw.githubusercontent.com/M0Rf30/android-udev-rules/main/51-android.rules -O /etc/udev/rules.d/51-android.rules
chmod 0644 /etc/udev/rules.d/51-android.rules
