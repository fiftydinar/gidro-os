#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Remove avif thumbnailer, as heif thumbnailer already caches it
rm "/usr/share/thumbnailers/avif.thumbnailer"
