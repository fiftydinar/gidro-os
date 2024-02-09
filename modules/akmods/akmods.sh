#!/usr/bin/env bash
set -euo pipefail

# Notify that build errors can occur if upstream akmods image did not update to match latest Fedora kernel.
# This error is printed only when build fails.

function ENABLE_MULTIMEDIA_REPO {
  sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
  sed -i "0,/enabled/ s@enabled=0@enabled=1@g" /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}

function DISABLE_MULTIMEDIA_REPO {
  sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}

function SET_HIGHER_PRIORITY_AKMODS_REPO {
  echo "priority=90" >> /etc/yum.repos.d/_copr_ublue-os-akmods.repo
}

get_yaml_array INSTALL '.install[]' "$1"

INSTALL_PATH=("${INSTALL[@]/#/\/tmp/rpms/kmods/*}")
INSTALL_PATH=("${INSTALL_PATH[@]/%/*.rpm}")
INSTALL_STR=$(echo "${INSTALL_PATH[*]}" | tr -d '\n')

if [[ ${#INSTALL[@]} -gt 0 ]]; then
  echo "Installing akmods"
  echo "Installing: $(echo "${INSTALL[*]}" | tr -d '\n')"
  if [[ "$BASE_IMAGE" =~ "surface" ]]; then
    SET_HIGHER_PRIORITY_AKMODS_REPO
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-surface-devel-matched $INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
  else
    SET_HIGHER_PRIORITY_AKMODS_REPO
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-devel-matched $INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
  fi  
fi

# Disable the 'set -e' option temporarily
set +e

if [ $? -eq 1 ]; then
    echo "If you get build-time error which says: \"Could not depsolve transaction\""
    echo "remember that issue could reside in upstream Universal Blue akmods repo"
    echo "which can happen when akmods image is not updated to match latest Fedora kernel release."
    echo
    echo "Please wait for upstream to solve this issue."
    echo "If this issue occurs for prolonged period of time, please report this issue to Universal Blue project."
    echo "https://github.com/ublue-os/akmods"
fi

# Re-enable the 'set -e' option
set -e
