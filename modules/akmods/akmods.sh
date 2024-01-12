#!/usr/bin/env bash
set -oue pipefail

echo "${BASE_IMAGE}"

get_yaml_array INSTALL '.install[]' "$1"

INSTALL_PATH=("${INSTALL[@]/#/\/tmp/rpms/kmods/*}")
INSTALL_PATH=("${INSTALL_PATH[@]/%/*.rpm}")
INSTALL_STR=$(echo "${INSTALL_PATH[*]}" | tr -d '\n')

if [[ ${#INSTALL[@]} -gt 0 ]]; then
  echo "Installing akmods"
  echo "Installing: $(echo "${INSTALL[*]}" | tr -d '\n')"

  if [[ "$IMAGE_DEVICES" == asus ]] || [ "$IMAGE_NVIDIA" == asus-nvidia ] || [ "$IMAGE_DEVICES" == surface ] || [ "$IMAGE_NVIDIA" == surface-nvidia ]; then
    rpm-ostree install kernel-tools "$INSTALL_STR"
    else
    rpm-ostree install kernel-devel-matched "$INSTALL_STR"
  fi  
fi
