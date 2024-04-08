#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

EXTENSION="Night Theme Switcher"
if [[ "${OS_VERSION}" == "39" ]]; then
  VERSION="75"
  echo "Installing v${VERSION} of the ${EXTENSION} extension for Fedora ${OS_VERSION}"
elif [[ "${OS_VERSION}" == "40" ]]; then
  VERSION="77"
  echo "Installing v${VERSION} of the ${EXTENSION} extension for Fedora ${OS_VERSION}"
else
  echo "This extension does not support the Fedora version of your image"
  exit 1
fi

# Supported archive formats are .zip, .tar.gz, .tgz & .tar
URL="https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension/-/releases/${VERSION}/downloads/nightthemeswitcher.zip"

TMP_DIR="/tmp/${EXTENSION}"
ARCHIVE=$(basename "${URL}")
ARCHIVE_DIR="${TMP_DIR}/${ARCHIVE}"

# Download archive
curl -L "${URL}" --create-dirs -o "${ARCHIVE_DIR}"

# Extract archive
if [[ "${ARCHIVE}" == *.zip ]]; then
    echo "Extracting ZIP archive"
    unzip "${ARCHIVE_DIR}" -d "${TMP_DIR}" > /dev/null
elif [[ "${ARCHIVE}" == *.tar.gz || "${ARCHIVE_DIR}" == *.tgz ]]; then
    echo "Extracting TAR.GZ archive"
    tar -xzvf "${ARCHIVE_DIR}" -C "${TMP_DIR}" > /dev/null
elif [[ "${ARCHIVE}" == *.tar ]]; then
    echo "Extracting TAR archive"
    tar -xvf "${ARCHIVE_DIR}" -C "${TMP_DIR}" > /dev/null
else
    echo "Unsupported archive format is used for extraction"
    exit 1
fi

# Remove archive
rm "${ARCHIVE_DIR}"

UUID=$(yq '.uuid' < "${TMP_DIR}/metadata.json")
SCHEMA_ID=$(yq '.settings-schema' < "${TMP_DIR}/metadata.json")

# Install main extension files
mkdir -p "/usr/share/gnome-shell/extensions/${UUID}/"
find "${TMP_DIR}" -mindepth 1 -maxdepth 1 ! -path "*locale*" ! -path "*schemas*" -exec cp -r {} /usr/share/gnome-shell/extensions/"${UUID}"/ \;

# Install schema
mkdir -p "/usr/share/glib-2.0/schemas/"
cp "${TMP_DIR}/schemas/${SCHEMA_ID}.gschema.xml" "/usr/share/glib-2.0/schemas/${SCHEMA_ID}.gschema.xml"

# Install languages
mkdir -p "/usr/share/locale/"
cp -r "${TMP_DIR}/locale"/* "/usr/share/locale/"

# Delete the temporary directory
rm -r "${TMP_DIR}"
