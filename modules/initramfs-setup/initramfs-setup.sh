#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"

cp -r "$MODULE_DIRECTORY"/initramfs-setup/initramfs-setup /usr/bin/initramfs-setup
cp -r "$MODULE_DIRECTORY"/initramfs-setup/initramfs-setup.service /usr/lib/systemd/system/initramfs-setup.service

get_yaml_array INCLUDE '.include[]' "$1"

root_location="/usr/share/bluebuild/initramfs-setup"
user_location="/usr/etc/bluebuild/initramfs-setup"

echo "Installing initramfs-setup"

if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  
  printf "Configuring following initramfs files:\n"
  for file in "${INCLUDE[@]}"; do
    printf "%s\n" "$file"
  done
  
  mkdir -p "$root_location"

  cp -r "$MODULE_DIRECTORY"/initramfs-setup/config/tracked "$root_location"/tracked
  printf "%s" "${INCLUDE[@]}" >> "$root_location"/tracked
fi

mkdir -p "$user_location"

echo "Copying user modification template file"
cp -r "$MODULE_DIRECTORY"/initramfs-setup/user-config/tracked "$user_location"/tracked

echo "Enabling initramfs-setup service"
systemctl enable -f initramfs-setup.service

echo "Initramfs-setup is successfully installed & configured"
