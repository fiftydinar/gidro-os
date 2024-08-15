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
      gsettings reset org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name
      gsettings reset org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps
      gsettings reset org.gnome.desktop.app-folders folder-children
      gsettings reset org.gnome.desktop.background picture-options
      gsettings reset org.gnome.desktop.background picture-uri
      gsettings reset org.gnome.desktop.background picture-uri-dark
      gsettings reset org.gnome.desktop.background primary-color
      gsettings reset org.gnome.desktop.background secondary-color
      gsettings reset org.gnome.desktop.input-sources sources
      gsettings reset org.gnome.desktop.input-sources mru-sources
      gsettings reset org.gnome.desktop.interface show-battery-percentage
      gsettings reset org.gnome.desktop.peripherals.keyboard numlock-state
      gsettings reset org.gnome.settings-daemon.plugins.power power-button-action
      gsettings reset org.gnome.shell favorite-apps
      gsettings reset org.gnome.system.locale region
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
    
# Configure Proton-GE
proton-ge ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring Proton-GE${normal}"
      echo 'Configure Proton-GE for better games support on Steam.'
      echo 'Install, Uninstall or Remove old Proton-GE? Press ESC to exit.'
      OPTION=$(ugum choose Uninstall Install "Remove old Proton-GE" Update "List installed Proton-GE versions")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust proton-ge <option>"
      echo "  <option>: Specify the quick option - 'list', 'update/upgrade', 'install', 'uninstall' or 'remove-old'"
      echo "  Use 'list' to list all installed Proton-GE versions."      
      echo "  Use 'update' or 'upgrade' to update/upgrade Proton-GE."
      echo "  Use 'remove-old' to uninstall old versions of Proton-GE."      
      echo "  Use 'install' to install Proton-GE."
      echo "  Use 'uninstall' to uninstall Proton-GE."
      exit 0
    fi    
    if [ "${OPTION,,}" == "install" ]; then
      FLATPAK=$(flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      SOURCE="/usr/etc/skel/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
      TARGET="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d/"
        if ! [[ -n $(find "$SOURCE" -maxdepth 1 -type d -name 'GE-Proton*') ]]; then
          cp -r "$SOURCE"/* "$TARGET"
          echo 'Proton-GE runner for Steam installed, but not enabled. Enable it in Steam Compatibility settings & restart Steam.'
        else
          printf "\e[1;31mERROR: Proton-GE runner for Steam is already installed.\e[0m\n" 1>&2
        fi  
      else
        printf "\e[1;31mERROR: Proton-GE cannot be installed because Steam is not installed.\e[0m\n" 1>&2
      fi
    elif [ "${OPTION,,}" == "update" ] || [ "${OPTION,,}" == "upgrade" ]; then
      FLATPAK=$(flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
        if [[ -n $(find "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d" -maxdepth 1 -type d -name 'GE-Proton*') ]]; then
          SOURCE="/usr/etc/skel/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
          TARGET="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"      
          for folder in "$SOURCE"/GE-Proton*; do
            SOURCE_VERSION=$(basename "$folder" | grep -oP 'GE-Proton\K\d+-\d+')
            found_duplicate=false
            for target_folder in "$TARGET"/GE-Proton*; do
              TARGET_VERSION=$(basename "$target_folder" | grep -oP 'GE-Proton\K\d+-\d+')
              if [[ "$SOURCE_VERSION" == "$TARGET_VERSION" ]]; then
                found_duplicate=true
                break
             fi  
        done
        if [[ "$found_duplicate" == true ]]; then
          printf "\e[1;31mERROR: Proton-GE runner with latest $SOURCE_VERSION version already exists.\e[0m\n" 1>&2
        else 
          cp -r "$folder" "$TARGET"
            echo 'Proton-GE runner for Steam updated, but not enabled. Enable it in Steam Compatibility settings & restart Steam.'          
        fi
        done
        else
          printf "\e[1;31mERROR: Proton-GE cannot be updated because Proton-GE is not installed.\e[0m\n" 1>&2
        fi  
      else
        printf "\e[1;31mERROR: Proton-GE cannot be updated because Steam is not installed.\e[0m\n" 1>&2
      fi  
    elif [ "${OPTION,,}" == "uninstall" ]; then
      FLATPAK=$(flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name 'GE-Proton*') ]]; then
        rm -rf "$DIR"/GE-Proton*
      fi
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*-GE-*') ]]; then
        rm -rf "$DIR"/*-GE-*
      fi
        echo 'Proton-GE uninstalled.'
      else
        printf "\e[1;31mERROR: Proton-GE cannot be uninstalled because Steam is not installed.\e[0m\n" 1>&2
      fi
    elif [ "$OPTION" == "Remove old Proton-GE" ] || [ "${OPTION,,}" == "remove-old" ]; then
      FLATPAK=$(flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name 'GE-Proton*') ]]; then
        find "$DIR" -maxdepth 1 -type d -name "GE-Proton*" -printf '%P\n' | sort -V | head -n -1 | xargs -I {} rm -rf "$DIR/{}"
      fi  
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*-GE-*') ]]; then
        rm -rf "$DIR"/*-GE-*
      fi  
        echo 'Old Proton-GE versions deleted.'
      else
        printf "\e[1;31mERROR: Cannot delete old Proton-GE because Steam is not installed.\e[0m\n" 1>&2
      fi
    elif [ "$OPTION" == "List installed Proton-GE versions" ] || [ "${OPTION,,}" == "list" ]; then
      DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
      if [[ -n $(find "$DIR" -maxdepth 1 -type d \( -name 'GE-Proton*' -o -name '*-GE-*' \) -printf '%P\n') ]]; then
        find "$DIR" -maxdepth 1 -type d \( -name 'GE-Proton*' -o -name '*-GE-*' \) -printf '%P\n'
      else
        printf "\e[1;31mERROR: Proton-GE is not installed.\e[0m\n" 1>&2
      fi  
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
      echo "  <option>: Specify the quick option - 'update', 'install' or 'uninstall'"
      echo "  Use 'update' to update Android platform-tools to latest version."
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
    elif [ "${OPTION,,}" == "update" ]; then
      if [[ "${CURRENT_STATE}" == "Not Installed" ]]; then
        printf "\e[1;31mERROR: Android platform-tools is not installed, so nothing can be updated.\e[0m\n" 1>&2
      elif [[ "${CURRENT_STATE}" == "Installed" ]] && [[ "${LATEST_VERSION}" -gt "${VERSION}" ]]; then
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
