#!/usr/bin/env bash
set -euo pipefail

# This is a workaround until proper solution comes for missing yq regression in new template
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq
