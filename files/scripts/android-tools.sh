#!/usr/bin/env bash

VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/pkgforge-dev/android-tools-AppImage/releases/latest))
curl -fLs --create-dirs https://github.com/pkgforge-dev/android-tools-AppImage/releases/download/${VER}/Android_Tools-${VER%@*}-anylinux-x86_64.AppImage -o /usr/bin/android-tools
chmod +x /usr/bin/android-tools
mkdir -p /tmp/android-tmp/
(
 cd /tmp/android-tmp/
 /usr/bin/android-tools --appimage-extract
)
readarray -t BINS < <(find /tmp/android-tmp/AppDir/bin/ -type f -printf "%f\n")
rm -rf /tmp/android-tmp/
for bin in "${BINS[@]}"; do
  case "$bin" in
    adb|fastboot|etc1tool|hprof-conv|make_f2fs|make_f2fs_casefold) ln -fs /usr/bin/android-tools /usr/bin/"$bin";;
  esac
done
