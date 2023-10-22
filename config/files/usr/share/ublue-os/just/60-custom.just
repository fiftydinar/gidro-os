# Include some of your custom scripts here!

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
