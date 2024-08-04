#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euxo pipefail

MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"
DF_MODULE_DIR="${MODULE_DIRECTORY}/default-flatpaks"

# File/dir variables
SYS_DEF_FLATPAKS_DIR="/usr/share/bluebuild/default-flatpaks"
USER_DEF_FLATPAKS_DIR="/usr/etc/bluebuild/default-flatpaks"
WIP_BUILD_TIME_CONFIG="${DF_MODULE_DIR}/system-config.yml"
WIP_BOOT_TIME_CONFIG="${DF_MODULE_DIR}/local-user-config.yml"
BUILD_TIME_CONFIG="${SYS_DEF_FLATPAKS_DIR}/config.yml"
BOOT_TIME_CONFIG="${USER_DEF_FLATPAKS_DIR}/config.yml"

# General flatpak variables
NOTIFY="$(echo "${1}" | yq -I=0 ".notify")"

# System flatpak variables
get_yaml_array SYSTEM_INSTALL ".system.install[]" "${1}"
get_yaml_array SYSTEM_REMOVE ".system.remove[]" "${1}"
SYSTEM_REPO_URL="$(echo "${1}" | yq -I=0 ".system.repo-url")"
SYSTEM_REPO_NAME="$(echo "${1}" | yq -I=0 ".system.repo-name")"
SYSTEM_REPO_TITLE="$(echo "${1}" | yq -I=0 ".system.repo-title")"

# User flatpak variables
get_yaml_array USER_INSTALL ".user.install[]" "${1}"
get_yaml_array USER_REMOVE ".user.remove[]" "${1}"
USER_REPO_URL="$(echo "${1}" | yq -I=0 ".user.repo-url")"
USER_REPO_NAME="$(echo "${1}" | yq -I=0 ".user.repo-name")"
USER_REPO_TITLE="$(echo "${1}" | yq -I=0 ".user.repo-title")"

# Set-up repos
# System repo
if [[ -n "${SYSTEM_REPO_URL}" ]]; then
  yq eval ".system.repo-url = \"${SYSTEM_REPO_URL}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
if [[ -n "${SYSTEM_REPO_NAME}" ]]; then
  yq eval ".system.repo-name = \"${SYSTEM_REPO_NAME}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
if [[ -n "${SYSTEM_REPO_TITLE}" ]]; then
  yq eval ".system.repo-title = \"${SYSTEM_REPO_TITLE}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
# User repo
if [[ -n "${USER_REPO_URL}" ]]; then
  yq eval ".user.repo-url = \"${USER_REPO_URL}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
if [[ -n "${USER_REPO_NAME}" ]]; then
  yq eval ".user.repo-name = \"${USER_REPO_NAME}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
if [[ -n "${USER_REPO_TITLE}" ]]; then
  yq eval ".user.repo-title = \"${USER_REPO_TITLE}\"" "${WIP_BUILD_TIME_CONFIG}" -i
fi
