#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Uncomment this when it's ready for startingpoint 
#BLING_DIRECTORY="${BLING_DIRECTORY:-"/tmp/bling"}"
#
#cp -r "$BLING_DIRECTORY"/files/usr/bin/initramfs-setup /usr/bin/initramfs-setup
#cp -r "$BLING_DIRECTORY"/files/usr/lib/systemd/system/initramfs-setup.service /usr/lib/systemd/system/initramfs-setup.service

get_yaml_array INCLUDE '.include[]' "$1"

if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  echo "Installing initramfs-setup"
  printf "Configuring following initramfs files:\n%s" "${INCLUDE[@]}"
  echo "# Set to true if you want initramfs to be rebuilt again.
# Rebuilding initramfs is useful if you are including dracut files.
# You will see \"Updating initramfs - Manual rebuild process is running\" boot screen message after you apply this change & reboot the system.

false" >> /usr/etc/ublue-os/initramfs/rebuilt
  echo "# This file can be modified by live-users if they want to have custom file location arguments in initramfs.
# Be sure to check if the arguments you want already exist in initramfs by issuing \`rpm-ostree initramfs-etc\` command before modifying this file.
# Here's an example on how to do that (ignore # symbol):
#
# /etc/vconsole.conf
# /etc/crypttab
# /etc/modprobe.d/my-modprobe.conf" >> /usr/etc/ublue-os/initramfs/tracked-custom
  echo -e "# This file should not be modified by the user, as it's used by the OS directly.\n" >> /usr/etc/ublue-os/initramfs/tracked
  printf "%s" "${INCLUDE[@]}" >> /usr/etc/ublue-os/initramfs/tracked
  echo "Initramfs-setup is successfully installed & configured"
fi
