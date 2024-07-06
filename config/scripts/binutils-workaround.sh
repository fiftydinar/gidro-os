#!/usr/bin/env bash

set -euo pipefail

# Alternatives cannot create symlinks on its own during build-time
# This happens for packages like binutils & binutils-gold
# So create the symlink manually after rpm-ostree install
if [[ -e /usr/bin/ld.bfd ]] && [[ -e /usr/bin/ld ]]; then
  echo "Applying binutils alternatives ld binary workaround"
  ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld
else
  echo "Binutils is not installed, so workaround is not needed"
fi
