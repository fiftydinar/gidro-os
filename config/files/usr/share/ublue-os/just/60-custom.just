# Include some of your custom scripts here!

# Necessary post-setup for Gidro-OS
post-setup:
  #!/usr/bin/env bash
  touch $HOME/Templates/Untitled\ Document
    echo '"New documents" context menu entry in Nautilus created.'
  nohup nautilus -w . &> /dev/null &
  sleep 0.5
  gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
  sleep 0.5
  pkill nautilus
    echo '"Sort folders first" setting in Nautilus applied.'  
  gsettings set org.gnome.desktop.peripherals.keyboard delay 226
    echo 'Lower keyboard delay when typing setting applied.'  
  gsettings set org.gnome.mutter check-alive-timeout 20000
    echo 'Extended Mutter "not responding" timeout setting applied.'    
  FLATPAK=$(flatpak list)
  if grep -q 'org.gnome.TextEditor' <<< ${FLATPAK}; then
  mkdir -p $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
  touch $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile
  cd $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/
  echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 11'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" > keyfile
  cd $HOME
    echo 'Gnome Text Editor pre-configured settings applied.'
  else
    echo 'Gnome Text Editor is not installed, settings not applied.'
  fi

  
# Remove close button from windows (useful for Logitech G305)
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
  echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 1>/dev/null
  echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 1>/dev/null
  if [ -d /sys/firmware/efi ]; then
    sudo grub2-mkconfig -o /etc/grub2-efi.cfg
        echo 'Hide UEFI GRUB logs during boot setting applied.'  
  else
    sudo grub2-mkconfig -o /etc/grub2.cfg
        echo 'Hide BIOS GRUB logs during boot setting applied.'   
  fi

# Set system to boot with the grub screen showing options (Default)
unhide-grub:
  #!/usr/bin/env bash
  sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
  sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
  sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
  if [ -d /sys/firmware/efi ]; then
    sudo grub2-mkconfig -o /etc/grub2-efi.cfg
        echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'  
  else
    sudo grub2-mkconfig -o /etc/grub2.cfg
        echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'   
  fi
