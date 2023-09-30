#!/usr/bin/env bash
set -oue pipefail

echo -e "\n[org/gnome/mutter]\nexperimental-features=['variable-refresh-rate']" | tee -a /usr/etc/dconf/db/local.d/01-gidro
