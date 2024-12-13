#!/usr/bin/env bash

set -euo pipefail

# WARNING!
# Won't work when Fedora starts to utilize UKIs (Unified Kernel Images).
# UKIs contain kernel + initramfs + microcode (& maybe some other stuff)

readarray -t QUALIFIED_KERNEL < <(find "/lib/modules/" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")

if [[ "${#QUALIFIED_KERNEL[@]}" -gt 1 ]]; then
  echo "ERROR: There are several versions of kernel's initramfs"
  echo "       Cannot determine which one to regenerate"
  echo "       There is a possibility that you have multiple kernels installed in the image"
  echo "       Please only include 1 kernel in the image to solve this issue"
  exit 1
fi

echo "Initramfs regeneration is performing for kernel version: ${QUALIFIED_KERNEL[*]}"
/usr/bin/dracut --no-hostonly --kver "${QUALIFIED_KERNEL[*]}" --reproducible -v --add ostree -f "/lib/modules/${QUALIFIED_KERNEL[*]}/initramfs.img"
chmod 0600 "/lib/modules/${QUALIFIED_KERNEL[*]}/initramfs.img"
