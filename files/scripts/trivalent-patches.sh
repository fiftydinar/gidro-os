#!/usr/bin/env bash

set -euo pipefail

# Install Trivalent selinux policy (fixes Trivalent not launching since v135)
# Prevent installing conflicting schilly
dnf5 -y config-manager setopt fedora-cdrtools.enabled=0
dnf5 -y config-manager setopt fedora-multimedia.enabled=0
dnf5 -y install selinux-policy-devel
mkdir -p ./selinux/trivalent
cd ./selinux/trivalent
SELINUX_POLICY_URL="https://raw.githubusercontent.com/secureblue/secureblue/refs/heads/live/files/scripts/selinux/trivalent"
curl -fLs "${SELINUX_POLICY_URL}/trivalent.fc"
curl -fLs "${SELINUX_POLICY_URL}/trivalent.if"
curl -fLs "${SELINUX_POLICY_URL}/trivalent.te"
curl -sSL "${SELINUX_POLICY_URL}/trivalent.sh" | bash
cd
dnf5 -y remove selinux-policy-devel
dnf5 -y config-manager setopt fedora-cdrtools.enabled=1
dnf5 -y config-manager setopt fedora-multimedia.enabled=1

# Assure that network sandbox is always disabled by default (to ensure that login data remains)
# https://github.com/fedora-silverblue/issue-tracker/issues/603

echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf

# Disable search engine choice screen

echo -e '\nCHROMIUM_FLAGS+=" --disable-search-engine-choice-screen"' >> /etc/trivalent/trivalent.conf
