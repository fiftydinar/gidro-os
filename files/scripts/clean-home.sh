#!/usr/bin/env bash

set -euo pipefail

cat << 'EOF' > /etc/profile.d/000_clean_home.sh
# Clean home directory without dotfiles (as much as possible - flatpak & some others don't respect this, while they should imo)
# Applications, Desktop, Documents, Downloads, Games, Local, Music, Pictures, Public, Templates, Videos
# Local/share, Local/state, Local/config, Local/cache

export XDG_GAMES_DIR="${HOME}/Games" \
       XDG_BIN_HOME="${HOME}/Applications" \
       XDG_DATA_HOME="${HOME}/Local/share" \
       XDG_STATE_HOME="${HOME}/Local/state" \
       XDG_CONFIG_HOME="${HOME}/Local/config" \
       XDG_CACHE_HOME="${HOME}/Local/cache" \
       PATH="${XDG_BIN_HOME}:${PATH}"

if [ ! -d "${HOME}/Applications" ]; then
  mkdir -p "${HOME}/Applications"
fi

if [ ! -d "${HOME}/Games" ]; then
  mkdir -p "${HOME}/Games"
fi

# Make Volatile dir
if [ ! -e "/tmp/${USER}-gidro-os/Volatile" ]; then
  mkdir -p "/tmp/${USER}-gidro-os/Volatile" && chmod -R 700 "/tmp/${USER}-gidro-os" || exit 1
  ln -s "/tmp/${USER}-gidro-os/Volatile" "${HOME}" >/dev/null 2>&1
fi

# Set some programs to respect XDG structure
alias wget="wget --hsts-file=${XDG_CONFIG_HOME}/wget/wget-hsts"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc" \
       GNUPGHOME="${XDG_DATA_HOME}/gnupg" \
       ANDROID_HOME="${XDG_STATE_HOME}/android" \
       RENPY_PATH_TO_SAVES="${XDG_DATA_HOME}" \
       HISTFILE="${XDG_STATE_HOME}/bash/history"
EOF

# Set pulse cookie location to XDG compliant directory
sed -i 's|^; cookie-file =.*|; cookie-file = $XDG_STATE_HOME/pulse/cookie|' /etc/pulse/client.conf

# Patch yafti to look into XDG compliant directory
cat << 'EOF' > /usr/share/ublue-os/firstboot/launcher/login-profile.sh
# Only process users with home directories, but skip the "root" user.
if [ "$(id -u)" != "0" ] && [ ! -z "$HOME" ] && [ -d "$HOME" ]; then
    # Ensure target file exists and is a symlink (not a regular file or dir).
    if [ -z "${XDG_CONFIG_HOME}" ]; then
      yafti_home_dir="${HOME}/.config/autostart"
    else
      yafti_home_dir="${XDG_CONFIG_HOME}/autostart"
    fi
    if [ ! -L "${yafti_home_dir}/ublue-firstboot.desktop" ]; then
        # Remove any leftovers or incorrect (non-link) files with the same name.
        rm -rf "${yafti_home_dir}/ublue-firstboot.desktop"

        # Create symlink to uBlue's autostart runner.
        # Note that "broken autostart symlinks" are harmless if they remain
        # after distro switching, and just cause a minor syslog warning. The
        # user can manually delete this file if they migrate away from uBlue.
        mkdir -p "${yafti_home_dir}"
        ln -s "/usr/share/ublue-os/firstboot/launcher/autostart.desktop" "${yafti_home_dir}/ublue-firstboot.desktop"
    fi
fi
EOF

# Patch Trivalent to fully support custom config directory
sed -i 's|\$HOME/.config|\$HOME/Local/config|g' /usr/lib64/trivalent/trivalent.sh
sed -i 's|\$HOME/.config|\$HOME/Local/config|g' /usr/lib64/trivalent/install_filter.sh