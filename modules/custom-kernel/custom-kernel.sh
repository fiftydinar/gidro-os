#!/usr/bin/env bash
set -oue pipefail

INSTALL=$(echo "$1" | yq -I=0 ".install")

if [[ $INSTALL == "fsync" ]]; then
  echo "Installing Fsync custom kernel:"
  wget https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-"${OS_VERSION}"/sentry-kernel-fsync-fedora-"${OS_VERSION}".repo -P /etc/yum.repos.d/
  rpm-ostree cliwrap install-to-root /
  rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:sentry:kernel-fsync \
  kernel \
  kernel-core \
  kernel-modules \
  kernel-modules-core \
  kernel-modules-extra \
  kernel-uki-virt
  echo "Installation of Fsync custom kernel finished!"
  else
  echo "Kernel is not/wrongly specified, please fix your input in recipe"
  exit 1
fi  
