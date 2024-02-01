#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Uncomment this when it's ready for startingpoint/bling
#MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"
#
#cp -r "$MODULE_DIRECTORY"/initramfs-setup/files/usr/bin/initramfs-setup /usr/bin/initramfs-setup
#cp -r "$MODULE_DIRECTORY"/initramfs-setup/files/usr/lib/systemd/system/initramfs-setup.service /usr/lib/systemd/system/initramfs-setup.service

get_yaml_array INCLUDE '.include[]' "$1"

echo "Installing initramfs-setup"

if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  
  printf "Configuring following initramfs files:\n"
  for file in "${INCLUDE[@]}"; do
    printf "%s\n" "$file"
  done
  
  mkdir -p /usr/share/ublue-os/initramfs

  echo "Writing 'tracked' file to initramfs directory with modifications"

  echo -e "# This file should not be modified by the user, as it's used by the OS directly.\n" > /usr/share/ublue-os/initramfs/tracked
  printf "%s" "${INCLUDE[@]}" >> /usr/share/ublue-os/initramfs/tracked
fi

mkdir -p /usr/etc/ublue-os/initramfs

echo "Writing 'tracked-custom' file to initramfs directory for live-user modifications"
echo "# This file can be modified by live-users if they want to have custom file location arguments in initramfs.
# Be sure to check if the arguments you want already exist in initramfs by issuing \`rpm-ostree initramfs-etc\` command before modifying this file.
# Also don't forget to copy your initramfs modification files if you have those.
# Here's an example on how to edit this file (ignore # symbol):
#
# /etc/vconsole.conf
# /etc/crypttab
# /etc/modprobe.d/my-modprobe.conf" > /usr/etc/ublue-os/initramfs/tracked-custom

# Uncomment this when it's ready for startingpoint/bling
#echo "Enabling initramfs-setup service"
#systemctl enable -f initramfs-setup.service
echo "Initramfs-setup is successfully installed & configured"
