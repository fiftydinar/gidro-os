#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Remove ublue-os udev rule & use packaged rules from android-tools instead
rpm-ostree uninstall android-udev-rules
rpm-ostree install android-tools
