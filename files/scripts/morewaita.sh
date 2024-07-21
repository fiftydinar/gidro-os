#!/usr/bin/env bash
set -euo pipefail

ICONS_DIR="/usr/share/icons"
MOREWAITA_DIR="$ICONS_DIR/MoreWaita"
MOREWAITA_MAIN_DIR="$ICONS_DIR/MoreWaita-main"

mkdir -p "$MOREWAITA_MAIN_DIR"
wget -q "https://github.com/somepaulo/MoreWaita/archive/refs/heads/main.zip" -O "$MOREWAITA_MAIN_DIR/main.zip"
unzip -q "$MOREWAITA_MAIN_DIR/main.zip" -d "$ICONS_DIR"
find "$MOREWAITA_MAIN_DIR" \( -name "*.build" -o -name "*.sh" -o -name "*.md" -o -name "*.py" -o -name "*.git" \) -type f -delete
rm -r "$MOREWAITA_MAIN_DIR/main.zip" "$MOREWAITA_MAIN_DIR/_dev" "$MOREWAITA_MAIN_DIR/.github" "$MOREWAITA_MAIN_DIR/.gitignore"
mv "$MOREWAITA_MAIN_DIR" "$MOREWAITA_DIR"

gtk-update-icon-cache -f -t "$MOREWAITA_DIR"
xdg-desktop-menu forceupdate
