#!/usr/bin/env bash

set -euo pipefail

# XDG-Autostart directory is created during first-install only
# This can be a problem for packages like setroubleshoot to install successfully during build-time
# So create the directory manually at the start of the build
mkdir -p /usr/etc/xdg/autostart
