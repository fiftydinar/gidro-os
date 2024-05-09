#!/usr/bin/env bash

set -euo pipefail

wget "https://github.com/fiftydinar/homefiles-gidro-os/archive/refs/heads/main.zip" -O "/tmp/homefiles-gidro-os/homefiles-gidro-os-main.zip"
unzip "/tmp/homefiles-gidro-os/homefiles-gidro-os-main.zip"

# Replace "dot_" files & folders with . prefix
find "/tmp/homefiles-gidro-os/homefiles-gidro-os-main" -depth -name 'dot_*' -execdir bash -c 'mv "$1" "$(echo "$1" | sed "s/dot_/\./")"' _ {} \;
# Delete "empty_" prefix from files
find "/tmp/homefiles-gidro-os/homefiles-gidro-os-main" -depth -type f -name 'empty_*' -execdir bash -c 'mv "$1" "$(echo "$1" | sed "s/empty_//")"' _ {} \;

shopt -s dotglob
cp -r "/tmp/homefiles-gidro-os/homefiles-gidro-os-main"/* "/usr/etc/skel/"
shopt -u dotglob
rm -r "/tmp/homefiles-gidro-os
