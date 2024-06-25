#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Update bootloader
bootupctl backend generate-update-metadata
