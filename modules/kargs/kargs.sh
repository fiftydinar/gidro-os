#!/usr/bin/env bash

set -euo pipefail

if ! command -v bootc &> /dev/null; then
  echo "ERROR: 'bootc' package is not installed, please install it, as it's necessary for injecting kargs."
  exit 1
fi

KARGS_D="/usr/lib/bootc/kargs.d"
BLUEBUILD_TOML="${KARGS_D}/bluebuild-kargs.toml"

get_json_array KARGS 'try .["kargs"][]' "${1}"
formatted_kargs=$(printf '"%s", ' "${KARGS[@]}")
formatted_kargs=${formatted_kargs%, }

ARCH=$(echo "${1}" | jq -r 'try .["arch"]')
# Default architecture to x86_64 if no value is provided
if [[ -z "${ARCH}" || "${ARCH}" == "null" ]]; then
  ARCH="x86_64"
fi
formatted_arch=$(echo "${ARCH}" | sed 's/[^, ]\+/"&"/g')

if [[ ${#KARGS[@]} -gt 0 ]]; then
  # Make kargs.d directory in case it doesn't exist
  mkdir -p "${KARGS_D}"
  # If bluebuild-kargs.toml already exists from the previous module run, append a new suffixed toml file instead
  if [[ -f "${BLUEBUILD_TOML}" ]]; then
    counter=1
    new_filename="${KARGS_D}/bluebuild-kargs-${counter}.toml"
    while [[ -f "${new_filename}" ]]; do
        counter=$((counter + 1))
        new_filename="${KARGS_D}/bluebuild-kargs-${counter}.toml"
    done
    BLUEBUILD_TOML="${new_filename}"
  fi
  # Write kargs to toml file
  echo "Writing following kernel arguments to kargs.d TOML file: '${KARGS[*]}'"
  echo "Those kernel arguments are applied to the following OS architecture(s): '${ARCH}'"
  cat <<EOF >> "${BLUEBUILD_TOML}"
kargs = [${formatted_kargs}]
match-architectures = [${formatted_arch}]
EOF
else
  echo "ERROR: You did not include any kernel arguments to inject in the image."
  exit 1
fi
