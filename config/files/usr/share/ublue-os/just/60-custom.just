import '100-bling.just'
# Include some of your custom scripts here!

# Configure window close button
configure-close-button  ARG="prompt":
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ ARG }}
    if [ "$OPTION" == "prompt" ]; then    
    echo "${bold}Configuring window close button${normal}"
    echo 'Hiding close button from windows can be useful for mouses which have special key mapped for closing applications.'
    echo 'Hide or Unhide close button? Press ESC to exit.'
    OPTION=$(ugum choose "Unhide (Default)" "Hide")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust hiding-grub <option>"
      echo "  <option>: Specify the quick option - 'hide' or 'unhide'"
      echo "  Use 'hide' to hide GRUB boot screen."
      echo "  Use 'unhide' to revert to defaults."
      exit 0
    fi    
    if [ "$OPTION,," == "Hide" ]; then
      gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
        echo 'Hide close button from windows setting applied.' 
    elif [ "$OPTION" == "Unhide (Default)" || [ "${OPTION,,}" == "unhide" ]; then
      gsettings reset org.gnome.desktop.wm.preferences button-layout
        echo 'Reverted setting "window close button" to defaults.'
    fi
    
# Configure GRUB screen with various options
configure-grub ARG="prompt":
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ ARG }}
    if [ "$OPTION" == "prompt" ]; then
    echo "${bold}Configuring GRUB${normal}"
    echo 'GRUB hiding option can be useful for making boot-times faster.'
    echo 'Hide or Unhide GRUB? Press ESC to exit.'
    OPTION=$(ugum choose "Unhide (Default)" "Hide")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust hiding-grub <option>"
      echo "  <option>: Specify the quick option - 'hide' or 'unhide'"
      echo "  Use 'hide' to hide GRUB boot screen."
      echo "  Use 'unhide' to revert to defaults."
      exit 0
    fi    
    if [ "$OPTION,," == "Hide" ]; then
      sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
      output=$(echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 2>&1) || echo "$output" && false
      output=$(echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 2>&1) || echo "$output" && false
      if [ -d /sys/firmware/efi ]; then
        output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
            echo 'Hide UEFI GRUB logs during boot setting applied.'  
      else
        output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
            echo 'Hide BIOS GRUB logs during boot setting applied.'   
      fi
    elif [ "$OPTION" == "Unhide (Default)" || [ "${OPTION,,}" == "unhide" ]; then
      sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
      sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
      sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
      if [ -d /sys/firmware/efi ]; then
        output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
            echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'  
      else
        output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
            echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'   
      fi
    fi
    
# Factory-reset Gidro-OS
factory-reset ARG="prompt":
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ ARG }}
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
    if [ "$OPTION" == "Factory-reset everything"  || [ "${OPTION,,}" == "all" ]; then
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      FILE="$HOME"/Templates/Untitled\ Document  
      touch "$FILE"
        echo '"New documents" context menu entry in Nautilus created.'    
      mkdir -p "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Text Editor pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Calculator pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'\nvolume-custom=true\nvolume-value=100\nafter-playback=2" | tee -a "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Clapper pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/epiphany]\nrestore-session-policy='crashed'" | tee -a "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Web pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/neithern/g4music]\nplay-background=true" | tee -a "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'G4Music pre-configured settings applied.'    
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed.'
      echo 'Factory-reset of everything completed. Please restart your system.' 
    elif [ "$OPTION" == "Factory-reset OS settings"  || [ "${OPTION,,}" == "settings" ]; then
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed. Please restart your system.'
    elif [ "$OPTION" == "Factory-reset Gidro-OS modified settings only" || [ "${OPTION,,}" == "settings-gidro-os" ]; then
      gsettings reset org.gnome.desktop.app-folders folder-children
      gsettings reset org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps
      gsettings reset org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name
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
      gsettings reset org.gnome.shell enabled-extensions
      gsettings reset org.gnome.shell favorite-apps
      gsettings reset-recursively org.gnome.shell.extensions.blur-my-shell
      gsettings reset-recursively org.gnome.shell.extensions.openweather
      gsettings reset-recursively org.gnome.shell.extensions.notifications-alert
      gsettings reset-recursively org.gnome.shell.extensions.middleclickclose
      dconf reset -f /org/gnome/shell/extensions/caffeine/
      dconf reset /org/gnome/shell/enabled-extensions
      dconf reset /org/gnome/shell/disabled-extensions
      dconf reset /system/locale/region
        echo 'Factory-reset of Gidro-OS settings only completed.'
    elif [ "$OPTION" == "Factory-reset apps" || [ "${OPTION,,}" == "apps" ]; then
      flatpak --system repair
      flatpak --user repair
        echo 'Repaired possibly non-working flatpaks.'
      flatpak --user uninstall --all --delete-data
        echo 'Uninstalled all user flatpaks.'
      rm -r "$HOME"/.var/app/*
        echo 'Removed all flatpak data.'
      mkdir -p "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Text Editor pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Calculator pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'\nvolume-custom=true\nvolume-value=100\nafter-playback=2" | tee -a "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Clapper pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/epiphany]\nrestore-session-policy='crashed'" | tee -a "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Web pre-configured settings applied.'
      mkdir -p "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/neithern/g4music]\nplay-background=true" | tee -a "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'G4Music pre-configured settings applied.'  
      echo 'Factory reset of all apps completed.'
    elif   [ "$OPTION" == "Factory-reset Gidro-OS modified apps settings only" || [ "${OPTION,,}" == "apps-gidro-os" ]; then
      rm -f "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
      mkdir -p "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Text Editor pre-configured settings applied.'
      rm -f "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile  
      mkdir -p "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Calculator pre-configured settings applied.'
      rm -f "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile  
      mkdir -p "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'\nvolume-custom=true\nvolume-value=100\nafter-playback=2" | tee -a "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Clapper pre-configured settings applied.'
      rm -f "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile  
      mkdir -p "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/
      touch "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile
      output=$(echo -e "[org/gnome/epiphany]\nrestore-session-policy='crashed'" | tee -a "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'Web pre-configured settings applied.'
      rm -f "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile      
      mkdir -p "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/
      touch "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile
      output=$(echo -e "[com/github/neithern/g4music]\nplay-background=true" | tee -a "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
        echo 'G4Music pre-configured settings applied.'  
      echo 'Factory reset of all apps completed.'
    fi
    
# Configure Proton-GE
proton-ge ARG="prompt":
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ ARG }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring Proton-GE${normal}"
      echo 'Configure Proton-GE for better games support on Steam.'
      echo 'Install, Uninstall or Remove old Proton-GE? Press ESC to exit.'
      OPTION=$(ugum choose "Remove old Proton-GE" "Uninstall" "Install")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust proton-ge <option>"
      echo "  <option>: Specify the quick option - 'install', 'uninstall' or 'remove-old'"
      echo "  Use 'install' to Install Proton-GE."
      echo "  Use 'uninstall' to uninstall Proton-GE."
      echo "  Use 'remove-old' to uninstall old versions of Proton-GE."
      exit 0
    fi    
    if [ "$OPTION,," == "Install" ]; then
      FLATPAK=$(/usr/bin/flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      cd "$HOME"/.var/app/com.valvesoftware.Steam/.local/share/Steam
      if [ ! -d "compatibilitytools.d" ]; then
          mkdir "compatibilitytools.d"
      fi
      cd "compatibilitytools.d"
      cp -r /usr/share/ProtonGE-gidro/*  "$HOME"/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d
        echo 'Proton-GE runner for Steam installed, but not enabled. Enable it in Steam Compatibility settings & restart Steam.'
      else
        echo 'ERROR: Proton-GE cannot be installed because Steam is not installed.'
      fi
    elif [ "$OPTION,," == "Uninstall" ]; then
      FLATPAK=$(/usr/bin/flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      rm -r "$HOME"/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d/*
        echo 'Proton-GE uninstalled.'
      else
        echo 'ERROR: Proton-GE cannot be uninstalled because Steam is not installed.'
      fi
    elif [ "$OPTION" == "Remove old Proton-GE" || [ "${OPTION,,}" == "remove-old" ]; then
      FLATPAK=$(/usr/bin/flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      cd "$HOME"/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d
      ls -d -v GE-Proton* | head -n -1 | xargs -r rm -r
        echo 'Old Proton-GE versions deleted.'
      cd "$HOME"  
      else
        echo 'ERROR: Cannot delete old Proton-GE because Steam is not installed.'
      cd "$HOME"
      fi
    fi
