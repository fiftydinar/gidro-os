#!/usr/bin/env bash

set -euo pipefail

echo "Installing secureblue Trivalent selinux policy"
echo "Disable Negativo repo, to prevent installing conflicting non-needed 'schily' package"
dnf5 -y config-manager setopt fedora-cdrtools.enabled=0
dnf5 -y config-manager setopt fedora-multimedia.enabled=0
echo "Install 'selinux-policy-devel' build package & it's dependencies"
dnf5 -y install selinux-policy-devel
echo "Downloading secureblue Trivalent selinux policy"
mkdir -p ./selinux/trivalent
cd ./selinux/trivalent
SELINUX_POLICY_URL="https://raw.githubusercontent.com/secureblue/secureblue/refs/heads/live/files/scripts/selinux/trivalent"
curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.fc" --output-dir "${PWD}"
curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.if" --output-dir "${PWD}"
curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.te" --output-dir "${PWD}"
curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.sh" --output-dir "${PWD}"
echo "Executing trivalent.sh script"
bash "${PWD}/trivalent.sh"
cd ../..
echo "Cleaning up build package 'selinux-policy-devel' & it's dependencies"
dnf5 -y remove selinux-policy-devel
echo "Enabling Negativo repos (as default state)"
dnf5 -y config-manager setopt fedora-cdrtools.enabled=1
dnf5 -y config-manager setopt fedora-multimedia.enabled=1

echo "Assure that network sandbox is always disabled by default (to ensure that login data remains)"
echo "https://github.com/fedora-silverblue/issue-tracker/issues/603"
echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf

echo "Disable search engine choice screen"
echo -e '\nCHROMIUM_FLAGS+=" --disable-search-engine-choice-screen"' >> /etc/trivalent/trivalent.conf

echo "Enable middle-click scrolling by default"
sed -i '/CHROMIUM_FLAGS+=" --disable-breakpad"/a\FEATURES+=",MiddleClickAutoscroll"' /etc/trivalent/trivalent.conf
