#!/usr/bin/env bash

set -euo pipefail

release_assets=$(curl -fLsS --retry 5 -H 'Accept: application/vnd.github+json' https://api.github.com/repos/kem-a/appimage-thumbnailer/releases/latest | jq -cr '.assets | map({(.name | tostring): .browser_download_url}) | add')
url=$(jq -cr '.[keys_unsorted[] | select(test("x86_64\\.rpm$"))]' <<< "${release_assets}")
curl -fLs --create-dirs "$url" -o /tmp/appimage-thumbnailer.rpm
dnf install -y /tmp/appimage-thumbnailer.rpm
rm /tmp/appimage-thumbnailer.rpm
