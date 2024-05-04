# Include some of your custom scripts here!

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
    
# Configure GRUB screen with various options
configure-grub ACTION="prompt":
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    CURRENT_STATE="Unhidden"
    if sudo grub2-editenv list | grep -q "menu_auto_hide=1"; then
      CURRENT_STATE="Hidden"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
    echo "${bold}Configuring GRUB${normal}"
    echo "GRUB screen is currently: ${bold}${CURRENT_STATE}${normal}"
    echo 'GRUB hiding option can be useful for making boot-times faster.'
    echo 'Hide or Unhide GRUB? Press ESC to exit.'
    OPTION=$(ugum choose "Unhide (Default)" Hide)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-grub <option>"
      echo "  <option>: Specify the quick option - 'hide' or 'unhide'"
      echo "  Use 'hide' to hide GRUB boot screen."
      echo "  Use 'unhide' to revert to defaults."
      exit 0
    fi    
    if [ "${OPTION,,}" == "hide" ]; then
      if ! sudo grub2-editenv list | grep -q "menu_auto_hide=1"; then
        sudo grub2-editenv - set menu_auto_hide=1
        if [ -d /sys/firmware/efi ]; then
          output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
              echo 'Hide UEFI GRUB logs during boot setting applied.'  
        else
          output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
              echo 'Hide BIOS GRUB logs during boot setting applied.'   
        fi
      else
        printf "\e[1;31mERROR: GRUB screen is already hidden, no change is made.\e[0m\n" 1>&2
      fi
    elif [ "$OPTION" == "Unhide (Default)" ] || [ "${OPTION,,}" == "unhide" ]; then
      if sudo grub2-editenv list | grep -q "menu_auto_hide=1"; then    
        sudo grub2-editenv - unset menu_auto_hide
        if [ -d /sys/firmware/efi ]; then
          output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
              echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'  
        else
          output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
              echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'   
        fi
      else
        printf "\e[1;31mERROR: GRUB screen is already present, no change is made.\e[0m\n" 1>&2
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
    OPTION=$(ugum choose "Factory-reset Gidro-OS modified apps settings only" "Factory-reset apps" "Factory-reset Gidro-OS modified settings only" "Factory-reset OS settings" "Factory-reset everything")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust factory-reset <option>"
      echo "  <option>: Specify the quick option - 'all', 'settings', 'settings-gidro-os', 'apps' or 'apps-gidro-os'"
      echo "  Use 'all' to to factory-reset everything."
      echo "  Use 'settings' to factory-reset settings."
      echo "  Use 'settings-gidro-os' to factory-reset Gidro-OS modified settings only."
      echo "  Use 'apps' to factory-reset apps."
      echo "  Use 'apps-gidro-os' to factory-reset Gidro-OS modified apps settings only."
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
        ["G4Music"]="$flatpak_data/com.github.neithern.g4music"
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
      gsettings reset-recursively org.gnome.shell.extensions.blur-my-shell
      gsettings reset-recursively org.gnome.shell.extensions.openweatherrefined
      gsettings reset-recursively org.gnome.shell.extensions.middleclickclose      
      gsettings reset-recursively org.gnome.shell.extensions.notifications-alert
      gsettings reset-recursively org.gnome.shell.extensions.Bluetooth-Battery-Meter
      gsettings reset-recursively org.gnome.shell.extensions.nightthemeswitcher
      gsettings reset-recursively org.gnome.shell.extensions.nightthemeswitcher.commands
      gsettings reset-recursively org.gnome.shell.extensions.nightthemeswitcher.time
      gsettings reset-recursively org.gnome.shell.extensions.nightthemeswitcher.color-scheme
      dconf reset -f /org/gnome/shell/extensions/caffeine/
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
        ["G4Music"]="$flatpak_data/com.github.neithern.g4music"
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
        ["G4Music"]="$flatpak_data/com.github.neithern.g4music"
      )
      for app in "${!apps[@]}"; do
        cp -r "${apps[$app]}" "$HOME/.var/app/"
        echo "${app} pre-configured settings applied."
      done
      echo 'Factory reset of Gidro-OS modified app settings completed.'
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
        if ! [[ -n $(find "$SOURCE" -maxdepth 1 -type d -name '*GE-Proton*' -print -quit) ]]; then
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
        if [[ -n $(find "$SOURCE" -maxdepth 1 -type d -name '*GE-Proton*' -print -quit) ]]; then
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
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*GE-Proton*' -print -quit) ]]; then
        rm -rf "$DIR"/GE-Proton*
      fi
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*-GE-*' -print -quit) ]]; then
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
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*GE-Proton*' -print -quit) ]]; then
        find "$DIR" -maxdepth 1 -type d -name "GE-Proton*" -printf '%P\n' | sort -V | head -n -1 | xargs -r rm -rf
      fi  
      if [[ -n $(find "$DIR" -maxdepth 1 -type d -name '*-GE-*' -print -quit) ]]; then
        rm -rf "$DIR"/*-GE-*
      fi  
        echo 'Old Proton-GE versions deleted.'
      else
        printf "\e[1;31mERROR: Cannot delete old Proton-GE because Steam is not installed.\e[0m\n" 1>&2
      fi
    elif [ "$OPTION" == "List installed Proton-GE versions" ] || [ "${OPTION,,}" == "list" ]; then
      DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d"
      if [[ -n $(find "$DIR" -maxdepth 1 -type d \( -name 'GE-Proton*' -o -name '*-GE-*' \) -printf '%P\n' -quit) ]]; then
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
