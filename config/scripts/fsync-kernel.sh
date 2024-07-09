#!/usr/bin/env bash

set -euo pipefail

if [ ! -f /usr/libexec/rpm-ostree/wrapped/dracut ]; then
  echo "Installing cliwrap"
  rpm-ostree cliwrap install-to-root /
else
  echo "Cliwrap is already installed"
fi

wget https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-${OS_VERSION}/sentry-kernel-fsync-fedora-${OS_VERSION}.repo -O /etc/yum.repos.d/_copr_kernel-fsync.repo

rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' \
kernel \
kernel-core-* \
kernel-modules-* \
kernel-uki-virt-*
