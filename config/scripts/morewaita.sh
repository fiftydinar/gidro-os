#!/usr/bin/env bash
set -oue pipefail

mkdir /usr/share/icons/MoreWaita-main
wget https://github.com/somepaulo/MoreWaita/archive/refs/heads/main.zip -O /usr/share/icons/MoreWaita-main/main.zip
cd /usr/share/icons/MoreWaita-main
unzip main.zip -d /usr/share/icons
find . \( -name "*.build" -o -name "*.sh" -o -name "*.md" -o -name "*.py" -o -name "*.git" \) -type f -delete
rm -r main.zip _dev .github .gitignore
mv /usr/share/icons/MoreWaita-main /usr/share/icons/MoreWaita
gtk-update-icon-cache -f -t /usr/share/icons/MoreWaita
xdg-desktop-menu forceupdate
