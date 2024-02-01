#!/usr/bin/env bash

set -euo pipefail

get_yaml_array INCLUDE '.include[]' "$1"

schema_test_location="/tmp/bluebuild-schema-test"
schema_location="/usr/share/glib-2.0/schemas"

echo "Installing gschema-overrides module"

if [[ ${#INCLUDE[@]} -gt 0 ]]; then
  for file in "${INCLUDE[@]}"; do
  if [[ $file == *.gschema.override ]]; then       
    printf "Applying following gschema-overrides:\n"
    for file in "${INCLUDE[@]}"; do
      printf "%s\n" "$file"
    done
    mkdir -p "$schema_test_location" "$schema_location"
    find "$schema_location" -type f ! -name "*.gschema.override" -exec cp {} "$schema_test_location" \;
    for file in "${INCLUDE[@]}"; do
      file_path="${schema_location}/${file//$'\n'/}"
      cp "$file_path" "$schema_test_location"
    done
    echo "Running error-test for your gschema-overrides. Aborting if failed."
    glib-compile-schemas --strict "$schema_test_location"
    echo "Compiling gschema to include your setting overrides"
    glib-compile-schemas "$schema_location" &>/dev/null
  else
    echo "Module failed because included files in module don't have .gschema.override extension."
  fi
  done
else
  echo "Module failed because no gschema-overrides are included into the module."
fi  
