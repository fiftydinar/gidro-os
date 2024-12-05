#!/usr/bin/env bash

set -euo pipefail

echo "Disable rpm-ostree layering"
sed -i '/^#*LockLayering=.*/s/.*/LockLayering=true/' /etc/rpm-ostreed.conf

echo "Disable general usage of dnf & it's symlinks like yum"
cat << EOF > /etc/profile.d/disable-layering.sh
dnf() {
  echo "Package/application layering is disabled in Gidro-OS to ensure that reliability & integrity of the system remains untouched,"
  echo "Please install applications through 'Software' application only."
  echo "Also see Gidro-OS wiki for more details about this:"
  echo "https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-rpm-ostree-installremove-or-dnf-installremove-doesnt-work-to-installremove-some-applications-"
}

dnf5() {
  echo "Package/application layering is disabled in Gidro-OS to ensure that reliability & integrity of the system remains untouched,"
  echo "Please install applications through 'Software' application only."
  echo "Also see Gidro-OS wiki for more details about this:"
  echo "https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-rpm-ostree-installremove-or-dnf-installremove-doesnt-work-to-installremove-some-applications-"
}

yum() {
  echo "Package/application layering is disabled in Gidro-OS to ensure that reliability & integrity of the system remains untouched,"
  echo "Please install applications through 'Software' application only."
  echo "Also see Gidro-OS wiki for more details about this:"
  echo "https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-rpm-ostree-installremove-or-dnf-installremove-doesnt-work-to-installremove-some-applications-"
}

export -f dnf
export -f dnf5
export -f yum
EOF
