#!/usr/bin/env bash

set -euo pipefail

# Update bootloader metadata inside the image, which will be utilized further by bootc in ISO to update the bootloader on system
bootupctl backend generate-update-metadata
