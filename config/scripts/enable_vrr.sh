#!/usr/bin/env bash
set -oue pipefail

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr mutter mutter-common gnome-control-center gnome-control-center-filesystem xorg-x11-server-Xwayland
echo "MUTTER_DEBUG_FORCE_KMS_MODE=simple" >> /usr/etc/environment
gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"
