#!/usr/bin/env bash

set -euo pipefail

# Assure that network sandbox is always disabled by default (to ensure that login data remains)
# https://github.com/fedora-silverblue/issue-tracker/issues/603

echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf

# Enable middle-click auto-scroll (also disables middle-click to paste)

echo -e '\nCHROMIUM_FLAGS+=" --enable-features=MiddleClickAutoscroll"' >> /etc/trivalent/trivalent.conf