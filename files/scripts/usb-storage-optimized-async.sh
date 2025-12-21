#!/bin/sh

set -eu

wget https://raw.githubusercontent.com/fiftydinar/usb-storage-optimized-async/refs/heads/main/usb-storage-optimized-async-service -O /usr/bin/usb-storage-optimized-async-service
chmod +x /usr/bin/usb-storage-optimized-async-service
wget https://raw.githubusercontent.com/fiftydinar/usb-storage-optimized-async/refs/heads/main/usb-storage-optimized-async-udev -O /usr/bin/usb-storage-optimized-async-udev
chmod +x usb-storage-optimized-async-udev
wget https://raw.githubusercontent.com/fiftydinar/usb-storage-optimized-async/refs/heads/main/usb-storage-optimized-async-service.service -O /usr/lib/systemd/system/usb-storage-optimized-async-service.service
wget https://raw.githubusercontent.com/fiftydinar/usb-storage-optimized-async/refs/heads/main/zz1-usb-storage-optimized-async-udev.rules -O /usr/lib/udev/rules.d/zz1-usb-storage-optimized-async-udev.rules
