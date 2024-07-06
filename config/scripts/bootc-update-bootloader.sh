#!/usr/bin/env bash

set -euo pipefail

# Update bootloader inside the image
bootupctl backend generate-update-metadata
