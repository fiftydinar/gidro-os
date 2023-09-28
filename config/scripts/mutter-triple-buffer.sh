#!/usr/bin/env bash

set -oue pipefail

rpm-ostree cliwrap install-to-root / && \
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:nxmbit:gnome-perf-patched mutter
