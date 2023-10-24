#!/usr/bin/env bash

set -oue pipefail

rpm-ostree initramfs-etc --track=/etc/crypttab --track=/etc/modprobe.d/modprobe-gidro.conf
