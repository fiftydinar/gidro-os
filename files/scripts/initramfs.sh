#!/usr/bin/env bash

set -euo pipefail

# WARNING!
# Won't work when Fedora starts to utilize UKIs (Unified Kernel Images).
# UKIs will contain kernel + initramfs + bootloader

readarray -t QUALIFIED_KERNEL < <(find "${KERNEL_MODULES_PATH}" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
KERNEL_MODULES_PATH="/usr/lib/modules"
INITRAMFS_IMAGE_FILENAME="initramfs.img"
INITRAMFS_IMAGE="${KERNEL_MODULES_PATH}/${QUALIFIED_KERNEL[*]}/${INITRAMFS_IMAGE}"

if [[ "${#QUALIFIED_KERNEL[@]}" -gt 1 ]]; then
  echo "ERROR: There are several versions of kernel's initramfs"
  echo "       Cannot determine which one to regenerate"
  echo "       There is a possibility that you have multiple kernels installed in the image"
  echo "       Please only include 1 kernel in the image to solve this issue"
  exit 1
fi

echo "Initramfs regeneration is performing for kernel version: ${QUALIFIED_KERNEL[*]}"
dracut --no-hostonly --kver "${QUALIFIED_KERNEL[*]}" --reproducible -v --add ostree -f "${INITRAMFS_IMAGE}"
chmod 0600 "${INITRAMFS_IMAGE}"
