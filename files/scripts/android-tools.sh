#!/usr/bin/env bash

VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/pkgforge-dev/android-tools-AppImage/releases/latest))
curl -fLs --create-dirs https://github.com/pkgforge-dev/android-tools-AppImage/releases/download/${VER}/Android_Tools-${VER%@*}-anylinux-x86_64.AppImage -o /usr/bin/android-tools
chmod +x /usr/bin/android-tools
mkdir -p /tmp/android-tmp/
(
 cd /tmp/android-tmp/
 /usr/bin/android-tools --appimage-extract
)
readarray -t BINS < <(find /tmp/android-tmp/AppDir/shared/bin/ -type f)
rm -rf /tmp/android-tmp/
for bin in "${BINS[@]}"; do
  case "$bin" in
    *xdg-open|*.hook|*.conf) continue;;
  esac
  ln -fs /usr/bin/android-tools /usr/bin/"$bin"
done
