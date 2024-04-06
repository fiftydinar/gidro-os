#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

wget https://gitlab.gnome.org/Archive/gnome-raw-thumbnailer/-/raw/master/data/raw-thumbnailer.xml -O /usr/share/mime/packages/miniaturo.xml
echo "[Thumbnailer Entry]
TryExec=/usr/bin/miniaturo
Exec=/usr/bin/miniaturo -s %s -i %i -o %o
MimeType=image/x-adobe-dng;image/x-canon-cr2;image/x-canon-crw;image/x-nikon-nef;image/x-olympus-orf;image/x-pentax-pef;image/x-sony-arw;image/x-epson-erf;image/x-minolta-mrw;" > /usr/share/thumbnailers/miniaturo.thumbnailer
