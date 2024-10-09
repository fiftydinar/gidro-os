# Configure window close button
configure-close-button  ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Present"
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
      echo "Usage: ujust configure-close-button <option>"
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
          echo 'Reverted setting "window close button" to defaults.'
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
      echo "Usage: ujust factory-reset <option>"
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
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      cp -r /usr/etc/skel/Templates "$HOME"/
        echo '"New documents" context menu entry in Nautilus created.'    
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["LibreWolf"]="$flatpak_data/io.gitlab.librewolf-community"
        ["Gapless"]="$flatpak_data/com.github.neithern.g4music"
        ["Folio"]="$flatpak_data/com.toolstack.Folio"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done    
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed.'
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
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["LibreWolf"]="$flatpak_data/io.gitlab.librewolf-community"
        ["Gapless"]="$flatpak_data/com.github.neithern.g4music"
        ["Folio"]="$flatpak_data/com.toolstack.Folio"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done 
      echo 'Factory reset of all apps completed.'
    elif [ "$OPTION" == "Factory-reset Gidro-OS modified apps settings only" ] || [ "${OPTION,,}" == "apps-gidro-os" ]; then
      flatpak_data="/usr/etc/skel/.var/app"
      declare -A apps=(
        ["Text Editor"]="$flatpak_data/org.gnome.TextEditor"
        ["Calculator"]="$flatpak_data/org.gnome.Calculator"
        ["Clapper"]="$flatpak_data/com.github.rafostar.Clapper"
        ["LibreWolf"]="$flatpak_data/io.gitlab.librewolf-community"
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
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Disabled"
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
      echo "Usage: ujust configure-scheduled-reboot <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to enable scheduled nightly reboot systemd service."
      echo "  Use 'disable' to revert to defaults."      
      exit 0
    fi
    if [ "${OPTION,,}" == "enable" ]; then
      if systemctl is-enabled nightly-reboot.timer | grep -q disabled; then
        sudo systemctl enable nightly-reboot.timer
        sudo systemctl start nightly-reboot.timer
        echo "Nightly scheduled reboot is enabled!"
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already enabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Disable (Default)" ] || [ "${OPTION,,}" == "disable" ]; then
      if systemctl is-enabled nightly-reboot.timer | grep -q enabled; then
        sudo systemctl disable nightly-reboot.timer
        sudo systemctl stop nightly-reboot.timer
        echo 'Reverted setting "nightly scheduled reboot" to defaults.'
      else
        printf "\e[1;31mERROR: Nightly scheduled reboot is already disabled, no change is made.\e[0m\n" 1>&2
      fi
    fi

# Install or update Android platform-tools
android-tools ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Not Installed"
    if command -v adb &> /dev/null && command -v fastboot &> /dev/null; then
      CURRENT_STATE="Installed"
    fi
    if [[ "${CURRENT_STATE}" == "Installed" ]]; then
      VERSION="$(adb --version | awk '/Version/ {sub(/-.*/, "", $2); print $2}')"
    fi
    URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring Android platform-tools${normal}"    
      echo "Android platform-tools is currently: ${bold}${CURRENT_STATE}${normal}"
      if [[ -n "${VERSION}" ]]; then
        echo "Installed version: ${bold}${VERSION}${normal}"
      fi
      LATEST_VERSION="$(curl -Ls https://developer.android.com/tools/releases/platform-tools | grep -Po '(?<=data-text=")[^"]*' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}" | head -1)"
      echo "Latest version: ${bold}${LATEST_VERSION}${normal}"
      echo "Pulls source directly from Google, since distro-packaged versions are broken"
      echo "Contains ADB & Fastboot among other binaries for debugging Android devices"
      echo "Installs to system-wide directory by default (/usr/local/bin/)"
      echo 'Install, Update or Uninstall Android platform-tools? Press ESC to exit.'
      OPTION=$(ugum choose Uninstall Install Update)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust android-tools <option>"
      echo "  <option>: Specify the quick option - 'update/upgrade', 'install' or 'uninstall'"
      echo "  Use 'update' or 'upgrade' to update/upgrade Android platform-tools to latest version."
      echo "  Use 'install' to install Android platform-tools."
      echo "  Use 'uninstall' to uninstall Android platform-tools."      
      exit 0
    fi
    if [ "${OPTION,,}" == "install" ]; then
      if [[ "${CURRENT_STATE}" == "Installed" ]]; then
        printf "\e[1;31mERROR: Android platform-tools is already installed.\e[0m\n" 1>&2
      elif [[ "${CURRENT_STATE}" == "Not Installed" ]]; then
        echo "Installing Android platform-tools..."
        mkdir -p /tmp/platform-tools/
        wget "${URL}" -O /tmp/platform-tools/platform-tools-latest-linux.zip
        unzip /tmp/platform-tools/platform-tools-latest-linux.zip -d /tmp/platform-tools/
        PLATFORM_TOOLS_FILES="$(find /tmp/platform-tools/platform-tools/*)"
        echo -e "${PLATFORM_TOOLS_FILES}" | sudo tee /usr/local/bin/platform-tools-file-list >/dev/null
        sudo sed -i 's/\/tmp\/platform-tools\/platform-tools\//\/usr\/local\/bin\//g' /usr/local/bin/platform-tools-file-list
        sudo cp -r /tmp/platform-tools/platform-tools/* /usr/local/bin/
        rm -r /tmp/platform-tools/
        echo "Android platform-tools is installed"
      fi
    elif [ "${OPTION,,}" == "update" ] || [ "${OPTION,,}" == "upgrade" ]; then
      if [[ "${CURRENT_STATE}" == "Not Installed" ]]; then
        printf "\e[1;31mERROR: Android platform-tools is not installed, so nothing can be updated.\e[0m\n" 1>&2
      elif [[ "${CURRENT_STATE}" == "Installed" ]] && [[ "${LATEST_VERSION}" > "${VERSION}" ]]; then
        echo "Removing old Android platform-tools files"
        readarray -t FILE_LIST < <(cat /usr/local/bin/platform-tools-file-list)
        for file in "${FILE_LIST[@]}"; do
            if [[ -e "${file}" ]]; then
              sudo rm -r "${file}"
            else
              echo "${file} is already removed"
            fi  
        done
        echo "Downloading new Android platform-tools version"
        mkdir -p /tmp/platform-tools/
        wget "${URL}" -O /tmp/platform-tools/platform-tools-latest-linux.zip
        unzip /tmp/platform-tools/platform-tools-latest-linux.zip -d /tmp/platform-tools/
        PLATFORM_TOOLS_FILES="$(find /tmp/platform-tools/platform-tools/*)"
        echo -e "${PLATFORM_TOOLS_FILES}" | sudo tee /usr/local/bin/platform-tools-file-list >/dev/null
        sudo sed -i 's/\/tmp\/platform-tools\/platform-tools\//\/usr\/local\/bin\//g' /usr/local/bin/platform-tools-file-list
        sudo cp -r /tmp/platform-tools/platform-tools/* /usr/local/bin/
        rm -r /tmp/platform-tools/
        echo "Android platform-tools is installed"
      else
        printf "\e[1;31mERROR: Latest Android platform-tools version is already installed.\e[0m\n" 1>&2
      fi  
    elif [ "${OPTION,,}" == "uninstall" ]; then
      if [[ "${CURRENT_STATE}" == "Not Installed" ]]; then
        printf "\e[1;31mERROR: Android platform-tools is not installed, so there is no need to uninstall.\e[0m\n" 1>&2
      elif [[ "${CURRENT_STATE}" == "Installed" ]]; then
        readarray -t FILE_LIST < <(cat /usr/local/bin/platform-tools-file-list)
        for file in "${FILE_LIST[@]}"; do
            if [[ -e "${file}" ]]; then
              sudo rm -r "${file}"
            else
              echo "${file} is already removed"
            fi  
        done
        sudo rm /usr/local/bin/platform-tools-file-list
        echo "Android platform-tools is uninstalled"
      fi  
    fi

# Configure Bluetooth headset profile
configure-bluetooth-headset-profile  ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Enabled"
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
      echo "Usage: ujust configure-bluetooth-headset-profile <option>"
      echo "  <option>: Specify the quick option - 'disable' or 'enable'"
      echo "  Use 'disable' to disable Bluetooth headset profile."
      echo "  Use 'enable' to revert to defaults."
      exit 0
    fi    
    if [ "${OPTION,,}" == "disable" ]; then
      if ! [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        sudo mkdir -p "${WIREPLUMBER_DIR}"
        sudo cp "${FILE_CONF}" "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
          systemctl --user restart wireplumber
          echo 'Disable Bluetooth headset profile setting applied.'
      else
        printf "\e[1;31mERROR: Bluetooth headset profile is already disabled, no change is made.\e[0m\n" 1>&2
      fi  
    elif [ "$OPTION" == "Enable (Default)" ] || [ "${OPTION,,}" == "enable" ]; then
      if [ $(find "${WIREPLUMBER_DIR}" -type f | wc -l) -eq 1 ] && [ -f "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}" ]; then
        sudo rm -r "${WIREPLUMBER_DIR}
      else
        sudo rm "${WIREPLUMBER_DIR}/${WIREPLUMBER_FILE}"
      fi  
        systemctl --user restart wireplumber
          echo 'Reverted setting "Bluetooth headset profile" to defaults.'
      else
        printf "\e[1;31mERROR: Bluetooth headset profile is already enabled, no change is made.\e[0m\n" 1>&2
      fi
    fi
