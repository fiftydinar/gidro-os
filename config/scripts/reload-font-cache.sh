#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

fc-cache --system-only --really-force /usr/share/fonts/nokia-font
