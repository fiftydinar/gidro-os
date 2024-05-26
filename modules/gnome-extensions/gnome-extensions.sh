#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euxo pipefail

get_yaml_array INSTALL '.install[]' "$1"
get_yaml_array UNINSTALL '.uninstall[]' "$1"

if [[ ${#INSTALL[@]} -lt 1 ]] && [[ ${#UNINSTALL[@]} -lt 1 ]]; then
  echo "ERROR: You did not specify the extension to install or uninstall in module recipe file"
  exit 1
fi

if ! command -v gnome-shell &> /dev/null; then 
  echo "ERROR: Your custom image is using non-Gnome desktop environment, where Gnome extensions are not supported"
  exit 1
fi

GNOME_VER=$(gnome-shell --version | sed 's/[^0-9]*\([0-9]*\).*/\1/')
echo "Gnome version: ${GNOME_VER}"

if [[ ${#INSTALL[@]} -gt 0 ]]; then
  for INSTALL_EXT in "${INSTALL[@]}"; do
      # Replaces whitespaces with %20 for install entries which contain extension name, since URLs can't contain whitespace
      WHITESPACE_HTML=$(echo "${INSTALL_EXT}" | sed 's/ /%20/g')
      # If only numbers are provided, than ID is inputted, otherwise, extension name
      URL_QUERY=$(curl -s "https://extensions.gnome.org/extension-query/?search=${WHITESPACE_HTML}")
      QUERIED_EXT=$(echo "${URL_QUERY}" | yq ".extensions[] | select(.name == \"${INSTALL_EXT}\")")
      if [[ -z "${QUERIED_EXT}" ]]; then
        echo "Extension '${INSTALL_EXT}' does not exist in https://extensions.gnome.org/ website"
        exit 1
      fi
      EXT_UUID=$(echo "${QUERIED_EXT}" | yq ".uuid")
      EXT_NAME=$(echo "${QUERIED_EXT}" | yq ".name")
      # Gets suitable extension version for Gnome version from the image
      SUITABLE_VERSION=$(echo "${QUERIED_EXT}" | yq ".shell_version_map[${GNOME_VER}].version")
      if [[ "${SUITABLE_VERSION}" == "null" ]]; then
        echo "Extension '${EXT_NAME}' is not compatible with Gnome v${GNOME_VER} in your image"
        exit 1
      fi
      # Removes every @ symbol from UUID, since extension URL doesn't contain @ symbol
      URL="https://extensions.gnome.org/extension-data/${EXT_UUID//@/}.v${SUITABLE_VERSION}.shell-extension.zip"
      TMP_DIR="/tmp/${EXT_UUID}"
      ARCHIVE=$(basename "${URL}")
      ARCHIVE_DIR="${TMP_DIR}/${ARCHIVE}"
      echo "Installing '${EXT_NAME}' Gnome extension with version ${SUITABLE_VERSION}"
      # Download archive
      wget --directory-prefix="${TMP_DIR}" "${URL}"
      # Extract archive
      echo "Extracting ZIP archive"
      unzip "${ARCHIVE_DIR}" -d "${TMP_DIR}" > /dev/null
      # Remove archive
      echo "Removing archive"
      rm "${ARCHIVE_DIR}"
      # Install main extension files
      echo "Installing main extension files"
      install -d -m 0755 "/usr/share/gnome-shell/extensions/${EXT_UUID}/"
      find "${TMP_DIR}" -mindepth 1 -maxdepth 1 ! -path "*locale*" ! -path "*schemas*" -exec cp -r {} "/usr/share/gnome-shell/extensions/${EXT_UUID}/" \;
      find "/usr/share/gnome-shell/extensions/${EXT_UUID}" -type d -exec chmod 0755 {} +
      find "/usr/share/gnome-shell/extensions/${EXT_UUID}" -type f -exec chmod 0644 {} +
      # Install schema
      if [[ -d "${TMP_DIR}/schemas" ]]; then
        echo "Installing schema extension file"
        install -d -m 0755 "/usr/share/glib-2.0/schemas/"
        install -D -p -m 0644 "${TMP_DIR}/schemas/"*.gschema.xml "/usr/share/glib-2.0/schemas/"
      fi  
      # Install languages
      # Locale is not crucial for extensions to work, as they will fallback to gschema.xml
      # Some of them might not have any locale at the moment
      # So that's why I made a check for directory
      if [[ -d "${TMP_DIR}/locale" ]]; then
        echo "Installing language extension files"
        install -d -m 0755 "/usr/share/locale/"
        cp -r "${TMP_DIR}/locale"/* "/usr/share/locale/"
      fi  
      # Delete the temporary directory
      echo "Cleaning up the temporary directory"
      rm -r "${TMP_DIR}"
      echo "Extension '${EXT_NAME}' is successfully installed"
      echo "----------------------------------DONE----------------------------------"
  done
fi

# Uninstall section goes here

# Compile gschema to include schemas from extensions
echo "Compiling gschema to include extension schemas"
glib-compile-schemas "/usr/share/glib-2.0/schemas/" &>/dev/null

echo "Finished the installation of Gnome extensions"
