alias upgrade := update

# Update system & flatpaks
update:
    #!/usr/bin/bash
    if command -v flatpak > /dev/null; then
      echo "----------System flatpak update section----------"
      echo
      flatpak --system update -y
      echo
      echo "----------User flatpak update section----------"
      echo
      flatpak --user update -y
    else
      echo "----------Flatpak update section----------"
      echo
      echo "- Flatpak is not installed, so no flatpaks to update"
    fi
    if command -v /usr/bin/am > /dev/null; then
      if ! ps aux | grep -v grep | grep -E -q " /sbin/am | /bin/am | /usr/sbin/am | /usr/bin/am | am " && [[ "$(systemctl --user is-active am-update.service)" == "inactive" ]]; then
        echo
        echo "----------AppImage update section----------"
        echo
        am update
      else
        echo
        echo "----------AppImage update section----------"
        echo
        echo "AM update or other conflicting processes are already running in the background"
      fi
    elif command -v /usr/local/bin/am > /dev/null; then
      echo
      echo "----------AppImage update section----------"
      echo
      am update
    elif command -v appman > /dev/null; then
      echo
      echo "----------AppImage update section----------"
      echo
      appman update
    else
      echo
      echo "----------AppImage update section----------"
      echo
      echo "- AM AppImage Manager is not installed, so no AppImages to update"
    fi
    if command -v /usr/bin/soar> /dev/null; then
      if ! ps aux | grep -v grep | grep -E -q " /sbin/soar | /bin/soar | /usr/sbin/soar | /usr/bin/soar | soar " && [[ "$(systemctl --user is-active soar-upgrade-packages.service)" == "inactive" ]]; then
        echo
        echo "----------Soar update section----------"
        echo
        soar update
      else
        echo
        echo "----------Soar update section----------"
        echo
        echo "Soar update or other conflicting processes are already running in the background"
      fi
    elif command -v "${XDG_BIN_HOME:-$HOME/.local/bin}/soar" > /dev/null; then
      echo
      echo "----------Soar update section----------"
      echo
      soar update
      soar self update
    else
      echo
      echo "----------Soar update section----------"
      echo
      echo "- Soar is not installed, so no packages to update"
    fi
    if ! ps aux | grep -v grep | grep -E -q " /sbin/bootc | /bin/bootc | /usr/sbin/bootc | /usr/bin/bootc | bootc " && [[ "$(systemctl --system is-active bootc-auto-update-without-reboot.service)" == "inactive" ]]; then
      echo
      echo "----------System update section----------"
      echo
      sudo bootc upgrade
    else
      echo
      echo "----------System update section----------"
      echo
      echo "System update or other related bootc process is already running in the background"
    fi

# Show changelog & history for system & flatpak updates
changelog:
    #!/usr/bin/bash
    echo "----------System update changelog----------"
    echo
    rpm-ostree db diff --changelogs

alias toggle-upgrades := toggle-updates

# Turn automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Disabled"
    if systemctl -q is-enabled bootc-auto-update-without-reboot.timer; then
      CURRENT_STATE="Enabled (Default)"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "Automatic updates are currently: ${bold}${CURRENT_STATE}${normal}"
      echo "Enable or Disable automatic updates? Press ESC to exit."
      OPTION=$(ugum choose "Enable (Default)" Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: just toggle-updates <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to revert to defaults."
      echo "  Use 'disable' to disable automatic updates."
      exit 0
    fi
    if [ "$OPTION" == "Enable (Default)" ] || [ "${OPTION,,}" == "enable" ]; then
      if [ "${CURRENT_STATE}" == "Disabled" ]; then
        run0 --background="" sh -c 'systemctl enable --now bootc-auto-update-without-reboot.timer && systemctl list-units --type=timer --all | grep -q 'flatpak-system-update.timer' && systemctl enable --now flatpak-system-update.timer'
        if systemctl --user list-units --type=timer --all | grep -q 'flatpak-user-update.timer'; then
          run0 systemctl enable --global flatpak-user-update.timer
        fi
        if systemctl --user list-units --type=timer --all | grep -q 'am-update.timer'; then
          run0 systemctl enable --global am-update.timer
        fi
        if systemctl --user list-units --type=timer --all | grep -q 'soar-upgrade-packages.timer'; then
          run0 systemctl enable --global soar-upgrade-packages.timer
        fi
        echo 'Reverted setting "automatic updates" to defaults (Enabled).'
      else
        printf "\e[1;31mERROR: Automatic updates are already enabled, no change is made.\e[0m\n" 1>&2
      fi
    elif [ "${OPTION,,}" == "disable" ]; then
      if [ "${CURRENT_STATE}" == "Enabled (Default)" ]; then
        run0 --background="" sh -c 'systemctl disable --now bootc-auto-update-without-reboot.timer && systemctl list-units --type=timer --all | grep -q 'flatpak-system-update.timer' && systemctl disable --now flatpak-system-update.timer'
        if systemctl --user list-units --type=timer --all | grep -q 'flatpak-user-update.timer'; then
          run0 systemctl disable --global flatpak-user-update.timer
        fi
        if systemctl --user list-units --type=timer --all | grep -q 'am-update.timer'; then
          run0 systemctl disable --global am-update.timer
        fi
        if systemctl --user list-units --type=timer --all | grep -q 'soar-upgrade-packages.timer'; then
          run0 systemctl disable --global soar-upgrade-packages.timer
        fi
        echo 'Disable automatic updates setting applied.'
      else
        printf "\e[1;31mERROR: Automatic updates are already disabled, no change is made.\e[0m\n" 1>&2
      fi  
    fi

alias upgrade-firmware := update-firmware

# Update device firmware
[no-exit-message]
update-firmware:
    fwupdmgr refresh --force
    fwupdmgr get-updates
    fwupdmgr update

# Show all messages from this boot
logs-this-boot:
    run0 --background="" sh -c 'journalctl -b 0'

# Show all messages from last boot
logs-last-boot:
    run0 --background="" sh -c 'journalctl -b -1'

# Check for local overrides in /etc/ vs /usr/etc/
check-local-overrides:
    run0 --background="" sh -c 'ostree admin config-diff'

# Clean up old + unused podman images, volumes & flatpak packages
clean-system:
    #!/usr/bin/bash
    if command -v podman > /dev/null; then
      podman image prune -af
      podman volume prune -f
    else
      echo "- Podman is not installed, so there's nothing to clean"
    fi
    if command -v flatpak > /dev/null; then
      flatpak uninstall --system --unused
      flatpak uninstall --user --unused
    else
      echo "- Flatpak is not installed, so there's nothing to clean"
    fi

# Configure window close button
configure-close-button ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Present (Default)"
    if gsettings get org.gnome.desktop.wm.preferences button-layout | grep -q "'appmenu:'"; then
      CURRENT_STATE="Hidden"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
    echo "${bold}Configuring window close button${normal}"    
    echo "Close button is currently: ${bold}${CURRENT_STATE}${normal}"
    echo 'Hiding close button from windows can be useful for mouses which have special key mapped for closing applications.'
    echo 'Hide or Unhide close button? Press ESC to exit.'
    OPTION=$(ugum choose "Unhide (Default)" Hide)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: just configure-close-button <option>"
      echo "  <option>: Specify the quick option - 'hide' or 'unhide'"
      echo "  Use 'hide' to hide close button."
      echo "  Use 'unhide' to revert to defaults."
      exit 0
    fi    
    if [ "${OPTION,,}" == "hide" ]; then
      if ! gsettings get org.gnome.desktop.wm.preferences button-layout | grep -q "'appmenu:'"; then
        gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
          echo 'Hide close button from windows setting applied.'
      else
        printf "\e[1;31mERROR: Close button is already hidden, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Unhide (Default)" ] || [ "${OPTION,,}" == "unhide" ]; then
      if gsettings get org.gnome.desktop.wm.preferences button-layout | grep -q "'appmenu:'"; then
        gsettings reset org.gnome.desktop.wm.preferences button-layout
          echo 'Reverted setting "window close button" to defaults (Present).'
      else
        printf "\e[1;31mERROR: Close button is already present, no change is made.\e[0m\n" 1>&2
      fi
    fi

# Configure scheduled nightly reboot
scheduled-reboot ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Disabled (Default)"
    if systemctl is-enabled nightly-reboot.timer | grep -q enabled; then
      CURRENT_STATE="Enabled"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring scheduled nightly reboot${normal}"    
      echo "Scheduled nightly reboot is currently: ${bold}${CURRENT_STATE}${normal}"
      echo 'Configure scheduled nightly reboot, which happens in 03:00.'
      echo 'Enable or Disable scheduled nightly reboot? Press ESC to exit.'
      OPTION=$(ugum choose "Disable (Default)" Enable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: just configure-scheduled-reboot <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to enable scheduled nightly reboot systemd service."
      echo "  Use 'disable' to revert to defaults."      
      exit 0
    fi
    if [ "${OPTION,,}" == "enable" ]; then
      if systemctl is-enabled nightly-reboot.timer | grep -q disabled; then
        run0 --background="" sh -c 'systemctl enable nightly-reboot.timer; systemctl start nightly-reboot.timer'
        echo "Nightly scheduled reboot is enabled!"
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already enabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Disable (Default)" ] || [ "${OPTION,,}" == "disable" ]; then
      if systemctl is-enabled nightly-reboot.timer | grep -q enabled; then
        run0 --background="" sh -c 'systemctl disable nightly-reboot.timer; systemctl stop nightly-reboot.timer'
        echo 'Reverted setting "nightly scheduled reboot" to defaults (Disabled).'
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already disabled, no change is made.\e[0m\n" 1>&2
      fi
    fi

# Configure Bluetooth headset profile
configure-bluetooth-headset-profile ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Enabled (Default)"
    FILE_CONF="/usr/share/bluebuild/gidro-os/51-disable-bluetooth-headphone-profile-switch.conf"
    WIREPLUMBER_DIR="/etc/wireplumber/wireplumber.conf.d"
    WIREPLUMBER_FILE="51-disable-bluetooth-headphone-profile-switch.conf"
    if [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
      CURRENT_STATE="Disabled"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
    echo "${bold}Configuring Bluetooth headset profile behavior${normal}"    
    echo "Bluetooth headset profile is currently: ${bold}${CURRENT_STATE}${normal}"
    echo 'Disabling Bluetooth headset profile can be useful if you do not use mic from Bluetooth headphones & want to avoid lower audio quality from sudden headset profile switch.'
    echo 'Enable or Disable Bluetooth headset profile? Press ESC to exit.'
    OPTION=$(ugum choose "Enable (Default)" Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: just configure-bluetooth-headset-profile <option>"
      echo "  <option>: Specify the quick option - 'disable' or 'enable'"
      echo "  Use 'disable' to disable Bluetooth headset profile."
      echo "  Use 'enable' to revert to defaults."
      exit 0
    fi    
    if [ "${OPTION,,}" == "disable" ]; then
      if ! [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        run0 --background="" sh -c "mkdir -p ${WIREPLUMBER_DIR}; cp ${FILE_CONF} ${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
        systemctl --user restart wireplumber
          echo 'Disable Bluetooth headset profile setting applied.'
      else
        printf "\e[1;31mERROR: Bluetooth headset profile is already disabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Enable (Default)" ] || [ "${OPTION,,}" == "enable" ]; then
      if [ $(find "${WIREPLUMBER_DIR}" -type f | wc -l) -eq 1 ] && [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        run0 --background="" rm -r "${WIREPLUMBER_DIR}"
        systemctl --user restart wireplumber
          echo 'Reverted setting "Bluetooth headset profile" to defaults.'
      elif [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        run0 --background="" rm "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
        systemctl --user restart wireplumber
          echo 'Reverted setting "Bluetooth headset profile" to defaults (Enabled).'
      elif [ ! -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        printf "\e[1;31mERROR: Bluetooth headset profile is already enabled, no change is made.\e[0m\n" 1>&2
      fi
    fi
