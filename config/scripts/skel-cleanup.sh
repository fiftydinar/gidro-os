#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Remove .mozilla folder from skel ($HOME)
rm -r /usr/etc/skel/.mozilla
