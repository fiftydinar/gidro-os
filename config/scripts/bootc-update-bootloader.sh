#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Update bootloader
/usr/bin/bootupctl backend generate-update-metadata
