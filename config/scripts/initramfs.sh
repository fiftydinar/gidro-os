#!/usr/bin/env bash

set -euo pipefail

mkdir -p /var/tmp
mkdir -p /root
rpm-ostree cliwrap install-to-root /
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//')"
/usr/libexec/rpm-ostree/wrapped/dracut --no-hostonly --kver "${QUALIFIED_KERNEL}" --reproducible -v --add ostree -f "/lib/modules/${QUALIFIED_KERNEL}/initramfs.img"
