#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

get_yaml_array GETTEXT_DOMAIN '.install.gettext-domain[]' "$1"

if [[ ${#GETTEXT_DOMAIN[@]} -gt 0 ]]; then
  for EXTENSION in "${GETTEXT_DOMAIN[@]}"; do
      URL="https://extensions.gnome.org/extension-data/${EXTENSION}.shell-extension.zip"
      TMP_DIR="/tmp/${EXTENSION}"
      ARCHIVE=$(basename "${URL}")
      ARCHIVE_DIR="${TMP_DIR}/${ARCHIVE}"
      # Download archive
       curl -L "${URL}" --create-dirs -o "${ARCHIVE_DIR}"
       # Extract archive
       echo "Extracting ZIP archive"
       unzip "${ARCHIVE_DIR}" -d "${TMP_DIR}" > /dev/null
       # Remove archive
       echo "Removing archive"
       rm "${ARCHIVE_DIR}"
       # Read necessary info from metadata.json
       echo "Reading necessary info from metadata.json"
       UUID=$(yq '.uuid' < "${TMP_DIR}/metadata.json")
       SCHEMA_ID=$(yq '.settings-schema' < "${TMP_DIR}/metadata.json")
       # Install main extension files
       echo "Installing main extension files"
       install -d -m 0755 "/usr/share/gnome-shell/extensions/${UUID}/"
       find "${TMP_DIR}" -mindepth 1 -maxdepth 1 ! -path "*locale*" ! -path "*schemas*" -type d -exec sh -c 'cp -r {} /usr/share/gnome-shell/extensions/"${UUID}"/ && chmod 0755 /usr/share/gnome-shell/extensions/"${UUID}"/{}' \; -o -type f -exec sh -c 'cp -r {} /usr/share/gnome-shell/extensions/"${UUID}"/ && chmod 0644 /usr/share/gnome-shell/extensions/"${UUID}"/{}' \; 
       # Install schema
       echo "Installing schema extension file"
       install -d -m 0755 "/usr/share/glib-2.0/schemas/"
       install -D -p -m 0644 "${TMP_DIR}/schemas/${SCHEMA_ID}.gschema.xml" "/usr/share/glib-2.0/schemas/${SCHEMA_ID}.gschema.xml"
       # Install languages
       echo "Installing language extension files"
       install -d -m 0755 "/usr/share/locale/"
       cp -r "${TMP_DIR}/locale"/* "/usr/share/locale/"
       # Delete the temporary directory
       echo "Cleaning up the temporary directory"
       rm -r "${TMP_DIR}"
       echo "------------------------------DONE----------------------------------"     
  done
else
  echo "ERROR: You did not specify gettext-domain"
  exit 1
fi

echo "Finished the installation of Gnome extensions"
