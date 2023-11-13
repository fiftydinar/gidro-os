#!/usr/bin/env bash
set -oue pipefail

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched gnome-shell mutter mutter-common
