alias upgrade := update

# Update system & flatpaks
update:
    #!/usr/bin/env bash
    echo "----------System update section----------"
    echo ""
    sudo bootc upgrade
    echo ""
    echo "----------System flatpak section----------"
    echo ""
    flatpak --system update -y
    echo ""
    echo "----------User flatpak section----------"
    echo ""
    flatpak --user update -y

# Show changelog & history for system & flatpak updates
changelog:
    #!/usr/bin/env bash
    echo "----------System update changelog----------"
    echo ""
    rpm-ostree db diff --changelogs
    echo ""
    echo "----------System flatpaks changelog----------"
    echo ""
    flatpak --system history
    echo ""
    echo "----------User flatpaks changelog----------"
    echo ""
    flatpak --user history

alias toggle-upgrades := toggle-updates

# Turn automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/run0 /usr/bin/bash
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
        systemctl enable --now flatpak-system-update.timer bootc-auto-update-without-reboot.timer
        systemctl enable --global flatpak-user-update.timer
        echo 'Reverted setting "automatic updates" to defaults (Enabled).'
      else
        printf "\e[1;31mERROR: Automatic updates are already enabled, no change is made.\e[0m\n" 1>&2
      fi
    elif [ "${OPTION,,}" == "disable" ]; then
      if [ "${CURRENT_STATE}" == "Enabled (Default)" ]; then
        systemctl disable --now flatpak-system-update.timer bootc-auto-update-without-reboot.timer
        systemctl disable --global flatpak-user-update.timer
        echo 'Disable automatic updates setting applied.'
      else
        printf "\e[1;31mERROR: Automatic updates are already disabled, no change is made.\e[0m\n" 1>&2
      fi  
    fi

alias upgrade-firmware := update-firmware

# Update device firmware
[no-exit-message]
update-firmware:
    #!/usr/bin/env bash
    fwupdmgr refresh --force
    fwupdmgr get-updates
    fwupdmgr update

# Show all messages from this boot
logs-this-boot:
    #!/usr/bin/run0 /usr/bin/bash
    journalctl -b 0

# Show all messages from last boot
logs-last-boot:
    #!/usr/bin/run0 /usr/bin/bash
    journalctl -b -1

# Check for local overrides in /etc/ vs /usr/etc/
check-local-overrides:
    #!/usr/bin/run0 /usr/bin/bash
    ostree admin config-diff

# Clean up old + unused podman images, volumes & flatpak packages
clean-system:
    #!/usr/bin/env bash
    podman image prune -af
    podman volume prune -f
    flatpak uninstall --system --unused
    flatpak uninstall --user --unused

# Configure window close button
configure-close-button ACTION="prompt":
    #!/usr/bin/env bash
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

# Factory-reset Gidro-OS
factory-reset ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then    
    echo "${bold}Configuring Factory-reset for Gidro-OS${normal}"
    echo 'Factory-reset of Gidro-OS can be used to solve or troubleshoot issues you may have.'
    echo 'Please select following factory-reset options. Press ESC to exit.'
    OPTION=$(ugum choose "Factory-reset Gnome extensions settings" "Factory-reset Gidro-OS modified apps settings only" "Factory-reset apps" "Factory-reset Gidro-OS modified settings only" "Factory-reset OS settings" "Factory-reset everything")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: just factory-reset <option>"
      echo "  <option>: Specify the quick option - 'all', 'settings', 'settings-gidro-os', 'apps', 'apps-gidro-os' or 'gnome-extensions'"
      echo "  Use 'all' to to factory-reset everything."
      echo "  Use 'settings' to factory-reset settings."
      echo "  Use 'settings-gidro-os' to factory-reset Gidro-OS modified settings only."
      echo "  Use 'apps' to factory-reset apps."
      echo "  Use 'apps-gidro-os' to factory-reset Gidro-OS modified apps settings only."
      echo "  Use 'gnome-extensions' to factory-reset modified settings for Gnome extensions only."
      exit 0
    fi
    if [ "$OPTION" == "Factory-reset everything" ] || [ "${OPTION,,}" == "all" ]; then
      mkdir -p "${HOME}"/.var/app/
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      if [[ -n "$(find "$HOME/.var/app/" -mindepth 1 -maxdepth 1 -type d)" ]]; then
        rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      else
        echo 'Flatpak data is already removed.'      
      fi
        echo 'Removed all flatpak data.'
      cp -r /usr/etc/skel/Templates "$HOME"/
        echo '"New documents" context menu entry in Nautilus created.'    
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["Gapless"]="$flatpak_data/com.github.neithern.g4music"
        ["Folio"]="$flatpak_data/com.toolstack.Folio"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done    
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed.'
      if [[ -f "${HOME}/.config/gtk-3.0/gtk.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-3.0/gtk.css"
      fi
      if [[ -f "${HOME}/.config/gtk-3.0/colors.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-3.0/colors.css"
      fi
      if [[ -f "${HOME}/.config/gtk-3.0/window_decorations.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-3.0/window_decorations.css"
      fi
      if [[ -f "${HOME}/.config/gtk-4.0/gtk.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-4.0/gtk.css"
      fi
      if [[ -f "${HOME}/.config/gtk-4.0/colors.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-4.0/colors.css"
      fi
      if [[ -f "${HOME}/.config/gtk-4.0/window_decorations.css" ]]; then
        custom_theming=true
        rm "${HOME}/.config/gtk-4.0/window_decorations.css"
      fi
      if ${custom_theming}; then
        echo 'Removed custom Gnome theming'
      fi
      echo 'Factory-reset of everything completed. Please restart your system.' 
    elif [ "$OPTION" == "Factory-reset OS settings" ] || [ "${OPTION,,}" == "settings" ]; then
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed. Please restart your system.'
    elif [ "$OPTION" == "Factory-reset Gidro-OS modified settings only" ] || [ "${OPTION,,}" == "settings-gidro-os" ]; then
      GSCHEMA_KEYS=($(read-gschema-keys "/usr/share/glib-2.0/schemas/zz1-gidro.gschema.override" "/usr/share/glib-2.0/schemas/zz2-bluebuild-wallpapers.gschema.override"))
      DCONF_KEYS=($(read-gschema-keys "/etc/dconf/db/distro.d/01-gidro"))
      for ((i=0; i<${#GSCHEMA_KEYS[@]}; i+=2)); do
        gsettings reset "${GSCHEMA_KEYS[i]}" "${GSCHEMA_KEYS[i+1]}"
      done
      for dconf_key in "${DCONF_KEYS[@]}"; do
        dconf reset "${dconf_key}"
      done  
      # This is needed to reset system & user extensions
      dconf reset -f /org/gnome/shell/extensions/
      gsettings reset org.gnome.shell enabled-extensions
      gsettings reset org.gnome.shell disabled-extensions
        echo 'Factory-reset of Gidro-OS settings only completed.'
    elif [ "$OPTION" == "Factory-reset apps" ] || [ "${OPTION,,}" == "apps" ]; then
      mkdir -p "${HOME}"/.var/app/
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      if [[ -n "$(find "$HOME/.var/app/" -mindepth 1 -maxdepth 1 -type d)" ]]; then
        rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      else
        echo 'Flatpak data is already removed.'      
      fi
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["Gapless"]="$flatpak_data/com.github.neithern.g4music"
        ["Folio"]="$flatpak_data/com.toolstack.Folio"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done 
      echo 'Factory reset of all apps completed.'
    elif [ "$OPTION" == "Factory-reset Gidro-OS modified apps settings only" ] || [ "${OPTION,,}" == "apps-gidro-os" ]; then
      mkdir -p "${HOME}"/.var/app/
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["Gapless"]="$flatpak_data/com.github.neithern.g4music"
        ["Folio"]="$flatpak_data/com.toolstack.Folio"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done
      echo 'Factory reset of Gidro-OS modified app settings completed.'
    elif [ "$OPTION" == "Factory-reset Gnome extensions settings" ] || [ "${OPTION,,}" == "gnome-extensions" ]; then
      dconf reset -f /org/gnome/shell/extensions/
      gsettings reset org.gnome.shell enabled-extensions
      gsettings reset org.gnome.shell disabled-extensions
        echo 'Factory-reset of Gnome extensions settings completed.'
    fi

# Configure scheduled nightly reboot
scheduled-reboot ACTION="prompt":
    #!/usr/bin/run0 /usr/bin/bash
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
        systemctl enable nightly-reboot.timer
        systemctl start nightly-reboot.timer
        echo "Nightly scheduled reboot is enabled!"
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already enabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Disable (Default)" ] || [ "${OPTION,,}" == "disable" ]; then
      if systemctl is-enabled nightly-reboot.timer | grep -q enabled; then
        systemctl disable nightly-reboot.timer
        systemctl stop nightly-reboot.timer
        echo 'Reverted setting "nightly scheduled reboot" to defaults (Disabled).'
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already disabled, no change is made.\e[0m\n" 1>&2
      fi
    fi

# Configure Bluetooth headset profile
configure-bluetooth-headset-profile ACTION="prompt":
    #!/usr/bin/run0 /usr/bin/bash
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
        mkdir -p "${WIREPLUMBER_DIR}"
        cp "${FILE_CONF}" "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
        systemctl --user restart wireplumber
          echo 'Disable Bluetooth headset profile setting applied.'
      else
        printf "\e[1;31mERROR: Bluetooth headset profile is already disabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Enable (Default)" ] || [ "${OPTION,,}" == "enable" ]; then
      if [ $(find "${WIREPLUMBER_DIR}" -type f | wc -l) -eq 1 ] && [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        rm -r "${WIREPLUMBER_DIR}"
        systemctl --user restart wireplumber
          echo 'Reverted setting "Bluetooth headset profile" to defaults.'
      elif [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        rm "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
        systemctl --user restart wireplumber
          echo 'Reverted setting "Bluetooth headset profile" to defaults (Enabled).'
      elif [ ! -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        printf "\e[1;31mERROR: Bluetooth headset profile is already enabled, no change is made.\e[0m\n" 1>&2
      fi
    fi
