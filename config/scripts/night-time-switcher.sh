#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

EXTENSION="night-time-switcher"
VERSION="75"
URL="https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/-/releases/${VERSION}/downloads/nightthemeswitcher.zip"

TMP_DIR="/tmp/${EXTENSION}"
ZIP_DIR="${TMP_DIR}/${EXTENSION}.zip"

curl -L "${URL}" --create-dirs -o "${ZIP_DIR}"
unzip "${ZIP_DIR}" -d "${TMP_DIR}"
rm "${ZIP_DIR}"

UUID=$(yq '.uuid' < ${TMP_DIR}/metadata.json)
SCHEMA_ID=$(yq '.settings-schema' < ${TMP_DIR}/metadata.json)

# Install main extension files
mkdir -p "/usr/share/gnome-shell/extensions/${UUID}/"
find "${TMP_DIR}" -mindepth 1 -maxdepth 1 ! -path "*locale*" ! -path "*schemas*" -exec cp -r {} /usr/share/gnome-shell/extensions/"${UUID}"/ \;

# Install schema
mkdir -p "/usr/share/glib-2.0/schemas/"
cp "${TMP_DIR}/schemas/${SCHEMA_ID}.gschema.xml" "/usr/share/glib-2.0/schemas/${SCHEMA_ID}.gschema.xml"

# Install languages
mkdir -p "/usr/share/locale/"
cp -r "${TMP_DIR}/locale"/* "/usr/share/locale/"

rm -r "${TMP_DIR}"
