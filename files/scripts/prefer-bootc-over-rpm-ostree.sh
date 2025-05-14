#!/usr/bin/env bash

set -euo pipefail

cat << 'EOF' > /etc/profile.d/prefer-bootc-over-rpm-ostree.sh
# Prefer 'bootc update/upgrade' & 'bootc switch' over rpm-ostree's equivalent functionality
rpm-ostree() {
  if [[ ${#} -eq 0 ]]; then
    /usr/bin/rpm-ostree
  elif [[ -n "$(awk '/(^|\s)('update'|'upgrade')($|\s)/' <<< "${@}")" ]]; then
    echo "ERROR: Don't use 'rpm-ostree update/upgrade', use 'sudo bootc update/upgrade' instead."
    echo "       Some functionality like kargs.d is only available when using bootc, hence why Gidro-OS slowly deprecates using rpm-ostree."
  elif [[ -n "$(awk '/(^|\s)('rebase')($|\s)/' <<< "${@}")" ]]; then
    echo "ERROR: Don't use 'rpm-ostree rebase', use 'sudo bootc switch' instead."
    echo "       Some functionality like kargs.d is only available when using bootc, hence why Gidro-OS slowly deprecates using rpm-ostree."
  else
    /usr/bin/rpm-ostree "${@}"
  fi
}

export -f rpm-ostree
EOF

# Patch bootc to not need sudo for updating

cat << 'EOF' > /etc/profile.d/bootc.sh
if [ "$EUID" -ne 0 ]; then
    bootc() {
        # Check if the command is already running with sudo
        if [ "$EUID" -eq 0 ]; then
            /usr/bin/bootc "$@"
        else
            sudo /usr/bin/bootc "$@"
        fi
    }
fi
EOF

cat << 'EOF' > /etc/sudoers.d/001-bootc
%wheel ALL=(ALL) NOPASSWD: /usr/bin/bootc update, /usr/bin/bootc upgrade, /usr/bin/bootc status, /usr/bin/bootc status --booted
EOF
