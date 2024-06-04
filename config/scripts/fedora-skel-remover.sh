#!/usr/bin/env bash

set -euo pipefail

SKEL="/usr/etc/skel"
# Remove empty .mozilla folder
if [[ -d "${SKEL}/.mozilla/" ]]; then
  echo "Removing ${SKEL}/.mozilla/ directory"
  rm -r "${SKEL}/.mozilla/"
fi
