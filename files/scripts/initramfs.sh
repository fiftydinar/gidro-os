#!/usr/bin/env bash

set -euo pipefail

# WARNING!
# Won't work when Fedora starts to utilize UKIs (Universal Kernel Images).
# UKIs contain kernel + initramfs + microcode (& maybe some other stuff)
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//')"
/usr/bin/dracut --no-hostonly --kver "${QUALIFIED_KERNEL}" --reproducible -v --add ostree -f "/lib/modules/${QUALIFIED_KERNEL}/initramfs.img"
chmod 0600 "/lib/modules/${QUALIFIED_KERNEL}/initramfs.img"
