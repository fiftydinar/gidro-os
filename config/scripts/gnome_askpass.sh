#!/usr/bin/env bash
set -oue pipefail

echo "SUDO_ASKPASS='/usr/libexec/openssh/gnome-ssh-askpass'" >> /usr/etc/environment
