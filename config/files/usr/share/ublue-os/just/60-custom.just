# Include some of your custom scripts here!

# Necessary post-setup for Gidro-OS
post-setup:
  #!/usr/bin/env bash
  output=`touch $HOME/Templates/Untitled\ Document 2>&1` || echo $output && false
    output=`echo '"New documents" context menu entry in Nautilus created.' 2>&1` || echo $output && false
  output=`nohup nautilus -w . 2>&1` || echo $output && false &
  output=`sleep 0.5 2>&1` || echo $output && false
  output=`gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true 2>&1` || echo $output && false
  output=`sleep 0.5 2>&1` || echo $output && false
  output=`pkill nautilus 2>&1` || echo $output && false
    output=`echo '"Sort folders first" setting in Nautilus applied.' 2>&1` || echo $output && false  
  output=`gsettings set org.gnome.desktop.peripherals.keyboard delay 226 2>&1` || echo $output && false
    output=`echo 'Lower keyboard delay when typing setting applied.' 2>&1` || echo $output && false  
  output=`gsettings set org.gnome.mutter check-alive-timeout 20000 2>&1` || echo $output && false
    output=`echo 'Extended Mutter "not responding" timeout setting applied.' 2>&1` || echo $output && false    
  output=`FLATPAK=$(flatpak list) 2>&1` || echo $output && false
  output=`if grep -q 'org.gnome.TextEditor' <<< ${FLATPAK}; then 2>&1` || echo $output && false
  output=`mkdir -p $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/ 2>&1` || echo $output && false
  output=`touch $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/keyfile 2>&1` || echo $output && false
  output=`cd $HOME/.var/app/org.gnome.TextEditor/config/glib-2.0/settings/ 2>&1` || echo $output && false
  output=`echo -e "[org/gnome/TextEditor]\nuse-system-font=false\ncustom-font='Nokia Pure Text 11'\nrestore-session=false\nshow-line-numbers=true\nstyle-scheme='kate'" > keyfile 2>&1` || echo $output && false
  output=`cd $HOME 2>&1` || echo $output && false
    output=`echo 'Gnome Text Editor pre-configured settings applied.' 2>&1` || echo $output && false
  else
    echo 'Error: Gnome Text Editor is not installed, settings not applied.' >&2
  fi

  
# Remove close button from windows (useful for Logitech G305)
hide-close-button:
  #!/usr/bin/env bash
  output=`gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:' 2>&1` || echo $output && false
    output=`echo 'Remove close button from windows setting applied.' 2>&1` || echo $output && false    
  
# Revert to include close button from windows (Default)
unhide-close-button:
  #!/usr/bin/env bash
  output=`gsettings reset org.gnome.desktop.wm.preferences button-layout 2>&1` || echo $output && false
    output=`echo 'Reverted setting "window close button" to defaults.' 2>&1` || echo $output && false  

# Set system to boot without showing the grub screen with options
hide-grub:
  #!/usr/bin/env bash
  output=`sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub 2>&1` || echo $output && false
  output=`echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 2>&1` || echo $output && false
  output=`echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 2>&1` || echo $output && false
  output=`if [ -d /sys/firmware/efi ]; then 2>&1` || echo $output && false
    output=`sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1` || echo $output && false
        output=`echo 'Hide UEFI GRUB logs during boot setting applied.' 2>&1` || echo $output && false  
  else
    output=`sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1` || echo $output && false
        output=`echo 'Hide BIOS GRUB logs during boot setting applied.' 2>&1` || echo $output && false   
  fi

# Set system to boot with the grub screen showing options (Default)
unhide-grub:
  #!/usr/bin/env bash
  output=`sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub 2>&1` || echo $output && false
  output=`sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub 2>&1` || echo $output && false
  output=`sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub 2>&1` || echo $output && false
  output=`if [ -d /sys/firmware/efi ]; then 2>&1` || echo $output && false
    output=`sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1` || echo $output && false
        output=`echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.' 2>&1` || echo $output && false  
  else
    output=`sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1` || echo $output && false
        output=`echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.' 2>&1` || echo $output && false   
  fi
