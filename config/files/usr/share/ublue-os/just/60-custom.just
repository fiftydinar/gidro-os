# Include some of your custom scripts here!

# Necessary post-setup for Gidro-OS (root)
post-setup-root:
  #!/usr/bin/env bash   
  sudo rm /etc/fwupd/remotes.d/lvfs-testing.conf
    echo 'Fwupd testing repo deleted.'

  gnome-software --quit
  output=`sudo /usr/lib/fedora-third-party/fedora-third-party-opt-out 2>&1` || echo $output && false
  sudo /usr/bin/fedora-third-party disable
    echo 'Gnome Software third-party repo prompt disabled.'

# Necessary post-setup for Gidro-OS (user)
post-setup-user
  #!/usr/bin/env bash
  touch $HOME/Templates/Untitled\ Document
    echo '"New documents" context menu entry in Nautilus created.'
    
  nohup nautilus -w . &> /dev/null &
  sleep 0.5
  gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
  sleep 0.5
  pkill nautilus
    echo '"Sort folders first" setting in Nautilus applied.'
    
  FLATPAK=$(flatpak list)
  if grep -q 'org.gnome.TextEditor' <<< ${FLATPAK}; then
  mkdir -p $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
  touch $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
  echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 16'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" | tee -a $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
    echo 'Gnome Text Editor pre-configured settings applied.'
  else
    echo 'ERROR: Gnome Text Editor is not installed, settings not applied.' >&2
  fi
  
  FLATPAK=$(flatpak list)
  if grep -q 'org.gnome.Calculator' <<< ${FLATPAK}; then
  mkdir -p $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/
  touch $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
  echo -e "[org/gnome/calculator]\nshow-thousands=true" | tee -a $HOME/.var/app/org.gnome.Calculator/config/glib-2.0/settings/keyfile
    echo 'Gnome Calculator pre-configured settings applied.'
  else
    echo 'ERROR: Gnome Calculator is not installed, settings not applied.' >&2
  fi
  
  FLATPAK=$(flatpak list)
  if grep -q 'com.github.rafostar.Clapper' <<< ${FLATPAK}; then
  mkdir -p $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/
  touch $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
  echo -e "[com/github/rafostar/Clapper]\nsubtitle-font='Nokia Pure Text 12'" | tee -a $HOME/.var/app/com.github.rafostar.Clapper/config/glib-2.0/settings/keyfile
    echo 'Clapper (Videos) pre-configured settings applied.'
  else
    echo 'ERROR: Clapper (Videos) is not installed, settings not applied.' >&2
  fi

# Remove close button from windows (useful for Logitech G305 mouse)
hide-close-button:
  #!/usr/bin/env bash
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
    echo 'Remove close button from windows setting applied.'    
  
# Revert to include close button from windows (Default)
unhide-close-button:
  #!/usr/bin/env bash
  gsettings reset org.gnome.desktop.wm.preferences button-layout
    echo 'Reverted setting "window close button" to defaults.'  

# Set system to boot without showing the grub screen with options
hide-grub:
  #!/usr/bin/env bash
  sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
  echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub
  echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub
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
  sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
  sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
  sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
  if [ -d /sys/firmware/efi ]; then
    output=`sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1` || echo $output && false
        echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'  
  else
    output=`sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1` || echo $output && false
        echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'   
  fi
