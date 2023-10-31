#!/usr/bin/env bash

set -oue pipefail

echo "vblank_mode=2" >> /usr/etc/environment
echo "MESA_VK_WSI_PRESENT_MODE=fifo" >> /usr/etc/environment
