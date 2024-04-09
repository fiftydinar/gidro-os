#!/usr/bin/env bash

set -euo pipefail

rpm --import https://dl.google.com/linux/linux_signing_key.pub

cat << EOF | tee /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
