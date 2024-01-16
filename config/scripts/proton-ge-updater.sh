#!/usr/bin/env bash
set -euo pipefail

# Get the latest Proton-GE-Custom release (url and filename)
url="$(curl -s "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest" | grep "browser_download_url.*\.tar\.gz" | cut -d \" -f 4)"
filename="$(echo "$url" | sed "s|.*/||")"

# Installation routine
install() {
    # make ProtonGE-gidro directory
    mkdir "$1"
    # cd into the given path
    cd "$1"
    # Check if current release is already installed
    if [ -d "$(echo "$filename" | sed "s|\.tar\.gz||")" ]; then
        echo "--> Current version is already installed."
        return 0
    else
        # Download latest release, extract the files and delete the archive
        echo "--> Downloading $filename..."
        curl -L "$url" --output "$filename"
        # Verify file integrity if sha512sum is availible and a hash can be obtained
        if hash sha512sum && sha512_hash=$(curl -Lf "${url%.tar.gz}.sha512sum" 2> /dev/null); then
            echo "--> Verfiying file integrity..."
            if ! printf '%s' "${sha512_hash%% *}  ${filename}" | sha512sum -c /dev/stdin; then
                # If stdin is a terminal, we ask whether
                # or not to accept a failed checksum,
                # but otherwise exit.
                if [ -t 0 ]; then
                    while true; do
                        printf '%s' "--> File integrity check failed. Continue?  (y/[N]) "
                        read -r REPLY
                        case "$REPLY" in
                            [yY][eE][sS]|[yY]) break ;;
                            [nN][oO]|[nN]|'') exit 1 ;;
                            *) echo "Invalid input..." ;;
                        esac
                    done
                else
                    echo "--> ERROR: File integrity check failed." 1>&2
                    exit 1
                fi
            fi
        else
            echo "--> Skipping file integrity check (hash not found)."
        fi
        echo "--> Extracting $filename..."
        tar -xf "$filename"
        echo "--> Removing the compressed archive..."
        rm "$filename"
        echo "--> Done. Please check the command line for errors and restart Steam for the changes to take effect."
        return 0
    fi
}

install "/usr/share/ProtonGE-gidro"
