#!/usr/bin/env bash
set -euo pipefail

# Variables
installation_path="/usr/etc/skel/.var/app/com.valvesoftware.Steam/.local/share/Steam/compatibilitytools.d/"

# Download the latest Proton-GE-Custom release (url and filename)
url="$(curl -s "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest" | grep "browser_download_url.*\.tar\.gz" | cut -d \" -f 4)"
filename="$(echo "$url" | sed "s|.*/||")"

# Function to download the release
download_release() {
    echo "--> Downloading $filename..."
    curl -L "$url" --output "$filename"
}

# Function to verify file integrity
verify_integrity() {
    echo "--> Verifying file integrity..."
    if hash sha512sum && sha512_hash=$(curl -Lf "${url%.tar.gz}.sha512sum" 2> /dev/null); then
        if ! printf '%s' "${sha512_hash%% *}  ${filename}" | sha512sum -c /dev/stdin; then
            echo "--> ERROR: File integrity check failed." 1>&2
            exit 1
        fi
    else
        echo "--> Skipping file integrity check (hash not found)."
    fi
}

# Function to extract the files
extract_files() {
    echo "--> Extracting $filename..."
    tar -xf "$filename"
}

# Function to remove the archive
remove_archive() {
    echo "--> Removing the compressed archive..."
    rm -f "$filename"
}

# Installation routine
install() {
    # Make installation directory
    mkdir -p "$1"

    # Check if current release is already installed
    if [ -d "$(echo "$filename" | sed "s|\.tar\.gz||")" ]; then
        echo "--> Current version is already installed."
        return 0
    else
        download_release
        verify_integrity
        extract_files
        remove_archive
        echo "--> Done. Please check the command line for errors and restart Steam for the changes to take effect."
        return 0
    fi
}

install "$installation_path"
