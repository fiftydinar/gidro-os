#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

rpm-ostree cliwrap install-to-root / && \
rpm-ostree override remove mutter --install=mutter

