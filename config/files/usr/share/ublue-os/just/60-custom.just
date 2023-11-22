# Include some of your custom scripts here!

# Necessary root post-setup for Gidro-OS
[private]
post-setup-root:
    #!/usr/bin/env bash
    FLATPAK=$(flatpak list)
    if grep -q 'com.usebottles.bottles' <<< ${FLATPAK}; then
    flatpak override --filesystem=home com.usebottles.bottles
      echo 'Bottles filesystem sandbox relax applied.'
    else
      echo 'ERROR: Bottles is not installed, filesystem sandbox relax not applied.' >&2
    fi

# Necessary user post-setup for Gidro-OS
[private]
post-setup-user:
    #!/usr/bin/env bash
    output=`touch $HOME/Templates/Untitled\ Document 2>&1` || echo $output && false
      echo '"New documents" context menu entry in Nautilus created.'

    FLATPAK=$(flatpak list)
    if grep -q 'org.gnome.TextEditor' <<< ${FLATPAK}; then
    output=`mkdir -p $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/ 2>&1` || echo $output && false
    output=`touch $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
    output=`echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
      echo 'Gnome Text Editor pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Text Editor is not installed, settings not applied.' >&2
    fi

    FLATPAK=$(flatpak list)
    if grep -q 'org.gnome.Calculator' <<< ${FLATPAK}; then
    output=`mkdir -p $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/ 2>&1` || echo $output && false
    output=`touch $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
    output=`echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
      echo 'Gnome Calculator pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Calculator is not installed, settings not applied.' >&2
    fi

    FLATPAK=$(flatpak list)
    if grep -q 'com.github.rafostar.Clapper' <<< ${FLATPAK}; then
    output=`mkdir -p $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/ 2>&1` || echo $output && false
    output=`touch $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
    output=`echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'" | tee -a $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
      echo 'Clapper (Videos) pre-configured settings applied.'
    else
      echo 'ERROR: Clapper (Videos) is not installed, settings not applied.' >&2
    fi   

    FLATPAK=$(flatpak list)
    if grep -q 'org.gnome.Epiphany' <<< ${FLATPAK}; then
    output=`mkdir -p $HOME/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/ 2>&1` || echo $output && false
    output=`touch $HOME/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
    output=`echo -e "[org/gnome/epiphany]\nrestore-session-policy='crashed'" | tee -a $HOME/.var/app/org.gnome.Epiphany/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
      echo 'Gnome Web pre-configured settings applied.'
    else
      echo 'ERROR: Gnome Web is not installed, settings not applied.' >&2
    fi   

# Remove close button from windows (useful for Logitech G305 mouse)
hide-close-button:
    #!/usr/bin/env bash
    output=`gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:' 2>&1` || echo $output && false
      echo 'Remove close button from windows setting applied.'    

# Revert to include close button from windows (Default)
unhide-close-button:
    #!/usr/bin/env bash
    output=`gsettings reset org.gnome.desktop.wm.preferences button-layout 2>&1` || echo $output && false
      echo 'Reverted setting "window close button" to defaults.'  

# Set system to boot without showing the grub screen with options
hide-grub:
    #!/usr/bin/env bash
    output=`sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub 2>&1` || echo $output && false
    output=`echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 2>&1` || echo $output && false
    output=`echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 2>&1` || echo $output && false
    if [ -d /sys/firmware/efi ]; then
      output=`sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1` || echo $output && false
          echo 'Hide UEFI GRUB logs during boot setting applied.'  
    else
      output=`sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1` || echo $output && false
          echo 'Hide BIOS GRUB logs during boot setting applied.'   
    fi

# Set system to boot with the grub screen showing options (Default)
unhide-grub:
    #!/usr/bin/env bash
    output=`sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub 2>&1` || echo $output && false
    output=`sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub 2>&1` || echo $output && false
    output=`sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub 2>&1` || echo $output && false
    if [ -d /sys/firmware/efi ]; then
      output=`sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1` || echo $output && false
          echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'  
    else
      output=`sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1` || echo $output && false
          echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'   
    fi

# Factory-reset all Gidro-OS configuration, including Gnome defaults
factory-reset:
    #!/usr/bin/env bash
    dconf reset -f /
      echo 'Factory-reset of all Gidro-OS settings completed.'

# Factory-reset Gidro-OS configuration, but keep modified Gnome defaults
factory-reset-keep:
    #!/usr/bin/env bash
    gsettings reset org.gnome.desktop.background picture-options
    gsettings reset org.gnome.desktop.background picture-uri
    gsettings reset org.gnome.desktop.background picture-uri-dark
    gsettings reset org.gnome.desktop.background primary-color
    gsettings reset org.gnome.desktop.background secondary-color
    gsettings reset org.gnome.desktop.interface show-battery-percentage
    gsettings reset org.gnome.settings-daemon.plugins.power power-button-action
    gsettings reset org.gnome.shell enabled-extensions
    gsettings reset org.gnome.shell favorite-apps
    gsettings reset-recursively org.gnome.shell.extensions.blur-my-shell
    gsettings reset-recursively org.gnome.shell.extensions.openweather
    gsettings reset system.locale region
      echo 'Factory-reset of Gidro-OS settings only completed.'

# Delete old Proton-GE versions, keep the latest one
delete-old-protonge:
    #!/usr/bin/env bash
    cd $HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d
    ls -d -v GE-Proton* | head -n -1 | xargs -r rm -r
      echo 'Old Proton-GE versions deleted.'
    cd $HOME

# Install Proton-GE runner for Steam
install-protonge:
    #!/usr/bin/env bash
    FLATPAK=$(flatpak list)
    if grep -q 'com.valvesoftware.Steam' <<< ${FLATPAK}; then
    cd $HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam
    if [ ! -d "compatibilitytools.d" ]; then
        echo "--> Creating folder for Steam compatibility tools..."
        mkdir "compatibilitytools.d"
    fi
    cd "compatibilitytools.d"
    cp -r /usr/share/ProtonGE-gidro/*  $HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d
      echo 'Proton-GE runner for Steam installed, but not enabled. Enable it in Steam Compatibility settings & restart Steam.'
    else
      echo 'Proton-GE cannot be installed because Steam is not installed.'
    fi
