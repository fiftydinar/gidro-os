#!/usr/bin/env bash
set -euo pipefail

ENABLE_MULTIMEDIA_REPO() {
  sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
  sed -i "0,/enabled/ s@enabled=0@enabled=1@g" /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}
readonly -f ENABLE_MULTIMEDIA_REPO

DISABLE_MULTIMEDIA_REPO() {
  sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
}
readonly -f DISABLE_MULTIMEDIA_REPO

SET_HIGHER_PRIORITY_AKMODS_REPO() {
  echo "priority=90" >> /etc/yum.repos.d/_copr_ublue-os-akmods.repo
}
readonly -f SET_HIGHER_PRIORITY_AKMODS_REPO

get_yaml_array INSTALL '.install[]' "$1"

readonly INSTALL_STR=(echo "/tmp/rpms/kmods/*${INSTALL[@]}*.rpm" | tr -d '\n')

if [[ ${#INSTALL[@]} -gt 0 ]]; then
  echo "Installing akmods"
  echo "Installing: $(echo "${INSTALL[*]}" | tr -d '\n')"
  SET_HIGHER_PRIORITY_AKMODS_REPO
  ENABLE_MULTIMEDIA_REPO
  rpm-ostree install ${INSTALL_STR}
  DISABLE_MULTIMEDIA_REPO
fi    
