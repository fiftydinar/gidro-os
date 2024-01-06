# Include some of your custom scripts here!

# Necessary root post-setup for Gidro-OS
[private]
post-setup-root:
    #!/usr/bin/env bash
    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'com.usebottles.bottles' <<< "${FLATPAK}"; then
    flatpak override --filesystem=home com.usebottles.bottles
      echo 'Bottles filesystem sandbox relax applied.'
    else
      echo 'ERROR: Bottles is not installed, filesystem sandbox relax not applied.' >&2
    fi

# Necessary user post-setup for Gidro-OS
[private]
post-setup-user:
    #!/usr/bin/env bash
    FILE=$HOME/Templates/Untitled\ Document
    if test -f "$FILE"; then
      echo 'ERROR: "New documents" context menu entry not created as it already exists.' >&2
    else  
    touch "$FILE"
      echo '"New documents" context menu entry in Nautilus created.'
    fi

    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'org.gnome.TextEditor' <<< "${FLATPAK}"; then
    rm -f "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
    mkdir -p "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
    touch "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
    output=$(echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a "$HOME"/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
      echo 'Gnome Text Editor pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Text Editor is not installed, settings not applied.' >&2
    fi

    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'org.gnome.Calculator' <<< "${FLATPAK}"; then
    rm -f "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
    mkdir -p "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/
    touch "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
    output=$(echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a "$HOME"/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
      echo 'Gnome Calculator pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Calculator is not installed, settings not applied.' >&2
    fi

    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'com.github.rafostar.Clapper' <<< "${FLATPAK}"; then
    rm -f "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
    mkdir -p "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/
    touch "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
    output=$(echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'\nvolume-custom=true\nvolume-value=100\nafter-playback=2" | tee -a "$HOME"/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
      echo 'Clapper (Videos) pre-configured settings applied.'
    else
      echo 'ERROR: Clapper (Videos) is not installed, settings not applied.' >&2
    fi   

    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'org.gnome.Epiphany' <<< "${FLATPAK}"; then
    rm -f "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile
    mkdir -p "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/
    touch "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile
    output=$(echo -e "[org/gnome/epiphany]\nrestore-session-policy='crashed'" | tee -a "$HOME"/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
      echo 'Gnome Web pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Web is not installed, settings not applied.' >&2
    fi   

    FLATPAK=$(/usr/bin/flatpak list --system --app --columns=application)
    if grep -q 'com.github.neithern.g4music' <<< "${FLATPAK}"; then
    rm -f "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile
    mkdir -p "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/
    touch "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile
    output=$(echo -e "[com/github/neithern/g4music]\nplay-background=true" | tee -a "$HOME"/.var/app/com.github.neithern.g4music/config/glib-2.0/settings/keyfile 2>&1) || echo "$output" && false
      echo 'G4Music pre-configured settings applied.'
    else
      echo 'ERROR: G4Music is not installed, settings not applied.' >&2
    fi

# Configure window close button
configure-close-button:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring window close button${normal}"
    echo 'Disabling close button from windows can be useful for mouses which have special key mapped for closing applications.'
    echo 'Enable or Disable close button? Press ESC to exit.'
    OPTION=$(ugum choose "Enable (Default)" "Disable")
    if [ "$OPTION" == "Disable" ]; then
      gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
        echo 'Disable close button from windows setting applied.' 
    if [ "$OPTION" == "Enable (Default)" ]; then
      gsettings reset org.gnome.desktop.wm.preferences button-layout
        echo 'Reverted setting "window close button" to defaults.'
    fi
    
# Configure GRUB screen with various options
hiding-grub:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring GRUB${normal}"
    echo 'GRUB hiding option can be useful for making boot-times faster.'
    echo 'Enable or Disable GRUB hiding? Press ESC to exit.'
    OPTION=$(ugum choose "Disable (Default)" "Enable")
    if [ "$OPTION" == "Enable" ]; then
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
    elif [ "$OPTION" == "Disable (Default)" ]; then
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
factory-reset:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring Factory-reset for Gidro-OS${normal}"
    echo 'Factory-reset of Gidro-OS can be used to solve or troubleshoot issues you may have.'
    echo 'Please select following factory-reset options. Press ESC to exit.'
    OPTION=$(ugum choose "Factory-reset Gidro-OS settings only" "Factory-reset all settings")
    if [ "$OPTION" == "Factory-reset all settings" ]; then
      dconf reset -f /
        echo 'Factory-reset of all Gidro-OS settings completed. Please restart your system.'
    elif [ "$OPTION" == "Factory-reset Gidro-OS settings only" ]; then
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
    fi
    
# Configure Proton-GE
proton-ge:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring Proton-GE${normal}"
    echo 'Configure Proton-GE for better games support on Steam.'
    echo 'Install, Uninstall or Remove old Proton-GE? Press ESC to exit.'
    OPTION=$(ugum choose "Remove old Proton-GE" "Uninstall" "Install")
    if [ "$OPTION" == "Install" ]; then
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
    elif [ "$OPTION" == "Uninstall" ]; then
      FLATPAK=$(/usr/bin/flatpak list --user --app --columns=application)
      if grep -q 'com.valvesoftware.Steam' <<< "${FLATPAK}"; then
      rm -r "$HOME"/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d/*
        echo 'Proton-GE uninstalled.'
      else
        echo 'ERROR: Proton-GE cannot be uninstalled because Steam is not installed.'
      fi
    elif [ "$OPTION" == "Remove old Proton-GE" ]; then
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
