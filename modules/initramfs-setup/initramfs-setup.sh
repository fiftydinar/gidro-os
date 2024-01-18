#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Uncomment this when it's ready for startingpoint/bling
#BLING_DIRECTORY="${BLING_DIRECTORY:-"/tmp/bling"}"
#
#cp -r "$BLING_DIRECTORY"/files/usr/bin/initramfs-setup /usr/bin/initramfs-setup
#cp -r "$BLING_DIRECTORY"/files/usr/lib/systemd/system/initramfs-setup.service /usr/lib/systemd/system/initramfs-setup.service

get_yaml_array INCLUDE '.include[]' "$1"

# If any inputted value is found, then install & configure
if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  echo "Installing initramfs-setup"
  
  printf "Configuring following initramfs files:\n"
  for file in "${INCLUDE[@]}"; do
    printf "%s\n" "$file"
  done
  
  mkdir -p /usr/etc/ublue-os/initramfs
  echo "Writing 'rebuilt' file to initramfs directory"
  
  echo "# Set to true if you want initramfs to be rebuilt again.
# Rebuilding initramfs is useful if you are including dracut files.
# You will see \"Updating initramfs - Manual rebuild process is running\" boot screen message after you apply this change & reboot the system.

false" > /usr/etc/ublue-os/initramfs/rebuilt

  echo "Writing 'tracked-custom' file to initramfs directory"
  echo "# This file can be modified by live-users if they want to have custom file location arguments in initramfs.
# Be sure to check if the arguments you want already exist in initramfs by issuing \`rpm-ostree initramfs-etc\` command before modifying this file.
# Here's an example on how to do that (ignore # symbol):
#
# /etc/vconsole.conf
# /etc/crypttab
# /etc/modprobe.d/my-modprobe.conf" > /usr/etc/ublue-os/initramfs/tracked-custom

  echo "Writing 'tracked' file to initramfs directory with user modifications"

  echo -e "# This file should not be modified by the user, as it's used by the OS directly.\n" > /usr/etc/ublue-os/initramfs/tracked
  
  printf "%s" "${INCLUDE[@]}" >> /usr/etc/ublue-os/initramfs/tracked
  # Uncomment this when it's ready for startingpoint/bling 
  #mkdir -p /usr/etc/flatpak/{system,user}
  #systemctl enable -f initramfs-setup.service
  echo "Initramfs-setup is successfully installed & configured"
  else
  echo "Initramfs-setup did not run installation & configuring step, be sure that values are typed correctly in recipe file"
  exit 1
fi
