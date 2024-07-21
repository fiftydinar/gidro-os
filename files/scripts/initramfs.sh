#!/usr/bin/env bash

set -euo pipefail

# Only install cliwrap if it's not already installed
# Usually needed when doing kernel-related changes with classic Fedora tools
# so those tools are aware of ostree nature of Fedora Atomic & adapt to it
# https://coreos.github.io/rpm-ostree/cliwrap/
if [[ ! -f "/usr/libexec/rpm-ostree/wrapped/dracut" ]]; then
  echo "Installing cliwrap"
  rpm-ostree cliwrap install-to-root /
else
  echo "Cliwrap is already installed"
fi

QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//')"
/usr/libexec/rpm-ostree/wrapped/dracut --no-hostonly --kver "${QUALIFIED_KERNEL}" --reproducible -v --add ostree -f "/lib/modules/${QUALIFIED_KERNEL}/initramfs.img"
chmod 0600 "/lib/modules/${QUALIFIED_KERNEL}/initramfs.img"
