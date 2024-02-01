#!/usr/bin/env bash

set -euo pipefail

get_yaml_array INCLUDE '.include[]' "$1"

schema_test_location="/tmp/bluebuild-schema-test"
schema_location="/usr/share/glib-2.0/schemas"

echo "Installing gschema-overrides module"

if [[ ${#INCLUDE[@]} == 0 ]]; then
  echo "Module failed because gschema-overrides aren't included into the module."
  exit 1
fi

if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  for file in "${INCLUDE[@]}"; do
    file="${file//$'\n'/}"
    if [[ ! $file == *.gschema.override ]]; then
      echo "Module failed because included files in module don't have .gschema.override extension."
      exit 1
    fi  
  done
else
  printf "Applying the following gschema-overrides:\n"
  for file2 in "${INCLUDE[@]}"; do
    file2="${file2//$'\n'/}"
    printf "%s\n" "$file2"
  done
  mkdir -p "$schema_test_location" "$schema_location"
  find "$schema_location" -type f ! -name "*.gschema.override" -exec cp {} "$schema_test_location" \;
  for file3 in "${INCLUDE[@]}"; do
    file_path="${schema_location}/${file3//$'\n'/}"
    cp "$file_path" "$schema_test_location"
  done
  echo "Running error-test for your gschema-overrides. Aborting if the test failed."
  glib-compile-schemas --strict "$schema_test_location"
  echo "Compiling gschema to include your setting overrides"
  glib-compile-schemas "$schema_location" &>/dev/null
fi
