# Include some of your custom scripts here!

# Necessary post-setup for Gidro-OS
post-setup:
  #!/usr/bin/env bash
  touch $HOME/Templates/Untitled\ Document
  gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
  gsettings set org.gnome.desktop.peripherals.keyboard delay 226
  gsettings set org.gnome.mutter check-alive-timeout 20000
  cd /usr/share/applications
  cp com.gerbilsoft.rom-properties.rp-config.desktop $HOME/.local/share/applications
  cd $HOME/.local/share/applications
  echo 'Hidden=true' >> com.gerbilsoft.rom-properties.rp-config.desktop
  cd $HOME
  
# Remove close button from windows (useful for Logitech G305)
hide-close-button:
  #!/usr/bin/env bash
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
  
# Revert to include close button from windows (Default)
unhide-close-button:
  #!/usr/bin/env bash
  gsettings reset org.gnome.desktop.wm.preferences button-layout

# Set system to boot without showing the grub screen with options
hide-grub:
  #!/usr/bin/env bash
  sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
  echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 1>/dev/null
  echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 1>/dev/null
  if [ -f '/boot/efi/EFI/fedora/grub.cfg' ]; then
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  else
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  fi

# Set system to boot with the grub screen showing options (Default)
unhide-grub:
  #!/usr/bin/env bash
  sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
  sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
  sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
  if [ -f '/boot/efi/EFI/fedora/grub.cfg' ]; then
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  else
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  fi
