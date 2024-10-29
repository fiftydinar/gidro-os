#!/usr/bin/env bash
# shellcheck disable=SC2128,SC2178

# Tell build process to exit if there are any errors.
set -euo pipefail

if ! command -v gnome-shell &> /dev/null; then 
  echo "ERROR: Your custom image is using non-Gnome desktop environment, where Gnome extensions are not supported"
  exit 1
fi

echo "Testing connection with https://extensions.gnome.org/..."
if ! curl --output /dev/null --silent --head --fail "https://extensions.gnome.org/"; then
  echo "ERROR: Connection unsuccessful."
  echo "       This usually happens when https://extensions.gnome.org/ website is down."
  echo "       Please try again later (or disable the module temporarily)"
  exit 1
else
  echo "Connection successful, proceeding."
fi  


GNOME_VER=46
INSTALL_EXT=6892

        # PK ID extension config fallback if specified
        URL_QUERY=$(curl -sf "https://extensions.gnome.org/extension-info/?pk=${INSTALL_EXT}")
        PK_EXT=$(echo "${URL_QUERY}" | jq -r '.["pk"]' 2>/dev/null)
        if [[ -z "${PK_EXT}" ]] || [[ "${PK_EXT}" == "null" ]]; then
          echo "ERROR: Extension with PK ID '${INSTALL_EXT}' does not exist in https://extensions.gnome.org/ website"
          echo "       Please assure that you typed the PK ID correctly,"
          echo "       and that it exists in Gnome extensions website"
          exit 1
        fi
        EXT_UUID=$(echo "${URL_QUERY}" | jq -r '.["uuid"]')
        EXT_NAME=$(echo "${URL_QUERY}" | jq -r '.["name"]')
        SUITABLE_VERSION=$(echo "${URL_QUERY}" | jq ".shell_version_map[\"${GNOME_VER}\"].version")  
      # Removes every @ symbol from UUID, since extension URL doesn't contain @ symbol
      URL="https://extensions.gnome.org/extension-data/${EXT_UUID//@/}.v${SUITABLE_VERSION}.shell-extension.zip"
      TMP_DIR="/tmp/${EXT_UUID}"
      ARCHIVE=$(basename "${URL}")
      ARCHIVE_DIR="${TMP_DIR}/${ARCHIVE}"
      echo "Installing '${EXT_NAME}' Gnome extension with version ${SUITABLE_VERSION}"
      # Download archive
      echo "Downloading ZIP archive ${URL}"
      curl -fLs --create-dirs "${URL}" -o "${ARCHIVE_DIR}"
      echo "Downloaded ZIP archive ${URL}"
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
        # Workaround for extensions, which explicitly require compiled schema to be in extension UUID directory (rare scenario due to how extension is programmed in non-standard way)
        # Error code example:
        # GLib.FileError: Failed to open file “/usr/share/gnome-shell/extensions/flypie@schneegans.github.com/schemas/gschemas.compiled”: open() failed: No such file or directory
        # If any extension produces this error, it can be added in if statement below to solve the problem
        # Fly-Pie or PaperWM
        if [[ "${EXT_UUID}" == "flypie@schneegans.github.com" || "${EXT_UUID}" == "paperwm@paperwm.github.com" ]]; then
          install -d -m 0755 "/usr/share/gnome-shell/extensions/${EXT_UUID}/schemas/"
          install -D -p -m 0644 "${TMP_DIR}/schemas/"*.gschema.xml "/usr/share/gnome-shell/extensions/${EXT_UUID}/schemas/"
          glib-compile-schemas "/usr/share/gnome-shell/extensions/${EXT_UUID}/schemas/" &>/dev/null
        else
          # Regular schema installation
          install -d -m 0755 "/usr/share/glib-2.0/schemas/"
          install -D -p -m 0644 "${TMP_DIR}/schemas/"*.gschema.xml "/usr/share/glib-2.0/schemas/"
        fi  
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
      # Modify metadata.json to support Gnome 47
      extension_location="/usr/share/gnome-shell/extensions/sleep-through-notifications@rhendric.gitlab.the_name_of_this_desktop_environment.org"
      if [[ ! "$(jq '.["shell-version"][]' "${extension_location}/metadata.json")" =~ "47" ]]; then
        echo "Modifying metadata.json to support Gnome 47"      
        jq '.["shell-version"] += ["47"]' "${extension_location}/metadata.json" > "${extension_location}/temp.json"
        mv "${extension_location}/temp.json" "${extension_location}/metadata.json"
      fi
      # Delete the temporary directory
      echo "Cleaning up the temporary directory"
      rm -r "${TMP_DIR}"
      echo "Extension '${EXT_NAME}' is successfully installed"
      echo "----------------------------------INSTALLATION DONE----------------------------------"

# Compile gschema to include schemas from extensions  & to refresh schema state after uninstall is done
echo "Compiling gschema to include extension schemas & to refresh the schema state"
glib-compile-schemas "/usr/share/glib-2.0/schemas/" &>/dev/null

