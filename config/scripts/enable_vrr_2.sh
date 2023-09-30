#!/usr/bin/env bash
set -oue pipefail

echo "experimental-features=['variable-refresh-rate']" >> /usr/etc/dconf/db/local.d/01-gidro
