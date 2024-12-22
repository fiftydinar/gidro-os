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
