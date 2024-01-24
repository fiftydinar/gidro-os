#!/usr/bin/env bash
set -euo pipefail

function ENABLE_MULTIMEDIA_REPO {
  sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
  sed -i "0,/enabled/ s@enabled=0@enabled=1@g" /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}

function DISABLE_MULTIMEDIA_REPO {
  sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}

get_yaml_array INSTALL '.install[]' "$1"

INSTALL_PATH=("${INSTALL[@]/#/\/tmp/rpms/kmods/*}")
INSTALL_PATH=("${INSTALL_PATH[@]/%/*.rpm}")
INSTALL_STR=$(echo "${INSTALL_PATH[*]}" | tr -d '\n')
XONE_INSTALL_STR=$(echo "$INSTALL_STR" | sed 's/xone//g')

if [[ ${#INSTALL[@]} -gt 0 ]]; then
  echo "Installing akmods"
  echo "Installing: $(echo "${INSTALL[*]}" | tr -d '\n')"
  # Surface images use special surface kernel
  if [[ "$BASE_IMAGE" =~ "surface" ]] && [[ "${INSTALL[@]}" =~ ! "xone" ]]; then
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-surface-devel-matched $INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
  # Xone requires disabled multimedia repo for it to work, applies for Surface images too
  elif [[ "$BASE_IMAGE" =~ "surface" ]] && [[ "${INSTALL[@]}" =~ "xone" ]]; then
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-surface-devel-matched $XONE_INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
    rpm-ostree install /tmp/rpms/kmods/*xone*.rpm
  # Xone requires disabled multimedia repo for it to work    
  elif [[ "$BASE_IMAGE" =~ ! "surface" ]] && [[ "${INSTALL[@]}" =~ "xone" ]]; then
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-devel-matched $XONE_INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
    rpm-ostree install /tmp/rpms/kmods/*xone*.rpm
  # Regular situation  
  elif [[ "$BASE_IMAGE" =~ ! "surface" ]] && [[ "${INSTALL[@]}" =~ ! "xone" ]]; then
    ENABLE_MULTIMEDIA_REPO
    rpm-ostree install kernel-devel-matched $INSTALL_STR
    DISABLE_MULTIMEDIA_REPO
  fi
fi
