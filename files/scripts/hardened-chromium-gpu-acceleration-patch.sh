#!/usr/bin/env bash

set -euo pipefail

# Patch hardened chromium config for GPU acceleration until the PR is merged:
# https://github.com/secureblue/hardened-chromium/pull/93

sed -i '/^GRAPHIC_DRIVER=default/c\GPU_INFO=$(lspci | grep -E "VGA|3D" | grep -o -i -E "amd|intel|nvidia" | sort -u | tr '\''[:upper:]'\'' '\''[:lower:]'\'' | xargs)\nif [ $(echo "$GPU_INFO" | wc -w) -gt 1 ]; then\n    GRAPHIC_DRIVER="default"\nelse\n    GRAPHIC_DRIVER=${GPU_INFO:-default}\nfi' /etc/chromium/chromium.conf