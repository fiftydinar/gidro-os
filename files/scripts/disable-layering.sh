#!/usr/bin/env bash

set -euo pipefail

echo "Disable rpm-ostree layering"
sed -i '/^#*LockLayering=.*/s/.*/LockLayering=true/' /etc/rpm-ostreed.conf

echo "Disable general usage of dnf & it's symlinks like yum"

REAL_PATH="/usr/libexec/dnf-orig"
mkdir -p "$REAL_PATH"

package_managers=(
"/usr/bin/dnf"
"/usr/bin/dnf5"
"/usr/bin/yum"
)

for pkg_mgr in "${package_managers[@]}"; do
base_name=$(basename "$pkg_mgr")
if [ -e "$pkg_mgr" ]; then
    mv "$pkg_mgr" "$REAL_PATH/$base_name"
fi

cat << EOF > "${pkg_mgr}"
#!/usr/bin/env bash

if systemd-detect-virt -cq || { [[ -e /run/.containerenv || -e /.dockerenv ]]; }; then
  exec "$REAL_PATH/$base_name" "\$@"
else
  echo "Package/application layering is disabled in Gidro-OS to ensure that reliability & integrity of the system remains untouched,"
  echo "Please install applications through 'Software' application only."
  echo "Also see Gidro-OS wiki for more details about this:"
  echo "https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-rpm-ostree-installremove-or-dnf-installremove-doesnt-work-to-installremove-some-applications-"
fi
EOF
done
