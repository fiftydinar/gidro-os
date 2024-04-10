#!/usr/bin/env bash

set -euo pipefail

# Alternatives cannot create symlinks on its own during build-time
# This happens for packages like binutils & binutils-gold
# So create the symlink manually after rpm-ostree install
ln -sf /usr/bin/ld.bfd /etc/alternatives/ld && ln -sf /etc/alternatives/ld /usr/bin/ld
