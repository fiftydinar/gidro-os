#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

get_yaml_array REPONAME '.reponame[]' "$1"
get_yaml_array PACKAGES '.packages[]' "$1"

# The installation is done with some wordsplitting hacks
# because of errors when doing array destructuring at the installation step.
# This is different from other ublue projects and could be investigated further.
REPONAME_STR=$(echo "${REPONAME[*]}" | tr -d '\n')
PACKAGES_STR=$(echo "${PACKAGES[*]}" | tr -d '\n')

# Install and remove RPM packages
if [[ ${#REPONAME[@]} -gt 0 && ${#PACKAGES[@]} -gt 0 ]]; then
    echo "Replacing integrated RPMs"
    echo "Replacing: ${PACKAGES_STR[*]}"
    # Doing both actions in one command allows for replacing required packages with alternatives
    rpm-ostree cliwrap install-to-root /
    rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:$REPONAME_STR $PACKAGES_STR
fi
