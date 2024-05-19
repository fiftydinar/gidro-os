#!/usr/bin/env bash

set -euo pipefail

MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"
HOMEFILES_BLUEBUILD="/usr/share/bluebuild/homefiles"
HOMEFILES_CONFIG="${HOMEFILES_BLUEBUILD}/config.yml"

# Copy homefiles binary
cp -r "${MODULE_DIRECTORY}/homefiles/homefiles" "/usr/bin/homefiles"
mkdir -p "${HOMEFILES_BLUEBUILD}/content"
cp -r "${MODULE_DIRECTORY}/homefiles/config.yml" "${HOMEFILES_CONFIG}"

# Gather homefiles config
USER_CREATION_ONLY_COPY=$(echo "${1}" | yq -I=0 ".user-creation-only-copy")
get_yaml_array USER_CREATION_ONLY_COPY_EXCEPTIONS '.user-creation-only-copy-exceptions[]' "${1}"
DUPLICATE_FILE_POLICY=$(echo "${1}" | yq -I=0 ".duplicate-file-policy")
get_yaml_array DUPLICATE_FILE_POLICY_EXCEPTIONS '.duplicate-file-policy-exceptions[]' "${1}"

echo "Writing module config"
yq -i '.user-creation-only-copy = ${USER_CREATION_ONLY_COPY}' "${HOMEFILES_CONFIG}"
# Not correct, have to check how yq works on this
yq -i '.user-creation-only-copy-exceptions[] = ${USER_CREATION_ONLY_COPY_EXCEPTIONS[@]}' "${HOMEFILES_CONFIG}" 
yq -i '.duplicate-file-policy = ${DUPLICATE_FILE_POLICY}' "${HOMEFILES_CONFIG}"
# Not correct, have to check how yq works on this
yq -i '.duplicate-file-policy-exceptions[] = ${DUPLICATE_FILE_POLICY_EXCEPTIONS[@]}' "${HOMEFILES_CONFIG}"

echo "Copying homefiles"
shopt -s dotglob
cp -r "${CONFIG_DIRECTORY}/homefiles"/* "${HOMEFILES_BLUEBUILD}/content/"
cp -r "${CONFIG_DIRECTORY}/homefiles"/* "$/usr/etc/skel/"
shopt -u dotglob
