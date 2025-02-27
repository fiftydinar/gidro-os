#!/usr/bin/env bash

set -euo pipefail

# Assure that network sandbox is always disabled by default (to ensure that login data remains)
# https://github.com/fedora-silverblue/issue-tracker/issues/603

# Disable search engine choice screen, as it has a bug that it constantly reappears when Google is selected

echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf
echo -e '\nCHROMIUM_FLAGS+=" --disable-search-engine-choice-screen"' >> /etc/trivalent/trivalent.conf
