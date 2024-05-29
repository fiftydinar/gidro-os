#!/usr/bin/env bash

set -euo pipefail

# Convince the installer that we are in CI
touch /.dockerenv

# Debugging
DEBUG="${DEBUG:-false}"
if [[ "${DEBUG}" == true ]]; then
    set -x
fi

# Check if gcc is installed
if ! command -v gcc &> /dev/null
then
    echo "ERROR: \"gcc\" package could not be found."
    echo "       Brew depends on \"gcc\" in order to function"
    echo "       Please include \"gcc\" in the list of packages to install with the system package manager"
    exit 1
fi

# Module-specific directories and paths
MODULE_DIRECTORY="${MODULE_DIRECTORY:-/tmp/modules}"

# Get list of brew packages to install
get_yaml_array PACKAGE_LIST '.packages[]' "${1}"

# Configuration values
UPDATE_INTERVAL=$(echo "${1}" | yq -I=0 ".update_interval")
if [[ -z "${UPDATE_INTERVAL}" || "${UPDATE_INTERVAL}" == "null" ]]; then
    UPDATE_INTERVAL="6h"
fi

UPGRADE_INTERVAL=$(echo "$1" | yq -I=0 ".upgrade_interval")
if [[ -z "${UPGRADE_INTERVAL}" || "${UPGRADE_INTERVAL}" == "null" ]]; then
    UPGRADE_INTERVAL="8h"
fi

WAIT_AFTER_BOOT_UPDATE=$(echo "${1}" | yq -I=0 ".wait_after_boot_update")
if [[ -z "${WAIT_AFTER_BOOT_UPDATE}" || "${WAIT_AFTER_BOOT_UPDATE}" == "null" ]]; then
    WAIT_AFTER_BOOT_UPDATE="10min"
fi

WAIT_AFTER_BOOT_UPGRADE=$(echo "${1}" | yq -I=0 ".wait_after_boot_upgrade")
if [[ -z "${WAIT_AFTER_BOOT_UPGRADE}" || "${WAIT_AFTER_BOOT_UPGRADE}" == "null" ]]; then
    WAIT_AFTER_BOOT_UPGRADE="30min"
fi

AUTO_UPDATE=$(echo "${1}" | yq -I=0 ".auto_update")
if [[ -z "${AUTO_UPDATE}" || "${AUTO_UPDATE}" == "null" ]]; then
    AUTO_UPDATE=true
fi

AUTO_UPGRADE=$(echo "${1}" | yq -I=0 ".auto_upgrade")
if [[ -z "${AUTO_UPGRADE}" || "${AUTO_UPGRADE}" == "null" ]]; then
    AUTO_UPGRADE=true
fi

NOFILE_LIMITS=$(echo "${1}" | yq -I=0 ".nofile_limits")
if [[ -z "${NOFILE_LIMITS}" || "${NOFILE_LIMITS}" == "null" ]]; then
    NOFILE_LIMITS=false
fi

BREW_ANALYTICS=$(echo "${1}" | yq -I=0 ".brew-analytics")
if [[ -z "${BREW_ANALYTICS}" || "${BREW_ANALYTICS}" == "null" ]]; then
    BREW_ANALYTICS=true
fi

# Create necessary directories
mkdir -p /var/home
mkdir -p /var/roothome

# Always install Brew
echo "Downloading and installing Brew..."
curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install

# Move Brew installation and set ownership to default user (UID 1000)
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew
cp -R /home/linuxbrew /usr/share/homebrew
chown -R 1000:1000 /usr/share/homebrew

# Write systemd service files dynamically
cat >/usr/lib/systemd/system/brew-setup.service <<EOF
[Unit]
Description=Setup Brew
Wants=network-online.target
After=network-online.target
ConditionPathExists=!/etc/.linuxbrew
ConditionPathExists=!/var/home/linuxbrew/.linuxbrew

[Service]
Type=oneshot
ExecStart=/usr/bin/mkdir -p /tmp/homebrew
ExecStart=/usr/bin/tar --zstd -xvf /usr/share/homebrew.tar.zst -C /tmp/homebrew
ExecStart=/usr/bin/cp -R -n /tmp/homebrew/home/linuxbrew/.linuxbrew /var/home/linuxbrew
ExecStart=/usr/bin/chown -R 1000:1000 /var/home/linuxbrew
ExecStart=/usr/bin/rm -rf /tmp/homebrew
ExecStart=/usr/bin/touch /etc/.linuxbrew

[Install]
WantedBy=default.target multi-user.target
EOF

cat >/usr/lib/systemd/system/brew-update.service <<EOF
[Unit]
Description=Auto update brew for mutable brew installs
After=local-fs.target
After=network-online.target
ConditionPathIsSymbolicLink=/home/linuxbrew/.linuxbrew/bin/brew

[Service]
User=1000
Type=oneshot
Environment=HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
Environment=HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
Environment=HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
ExecStart=/usr/bin/bash -c "/home/linuxbrew/.linuxbrew/bin/brew update"
EOF

cat >/usr/lib/systemd/system/brew-upgrade.service <<EOF
[Unit]
Description=Upgrade Brew packages
After=local-fs.target
After=network-online.target
ConditionPathIsSymbolicLink=/home/linuxbrew/.linuxbrew/bin/brew

[Service]
User=1000
Type=oneshot
Environment=HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
Environment=HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
Environment=HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
ExecStart=/usr/bin/bash -c "/home/linuxbrew/.linuxbrew/bin/brew upgrade"
EOF

# Write systemd timer files dynamically
cat >/usr/lib/systemd/system/brew-update.timer <<EOF
[Unit]
Description=Timer for brew update for mutable brew
Wants=network-online.target

[Timer]
OnBootSec=${WAIT_AFTER_BOOT_UPDATE}
OnUnitInactiveSec=${UPDATE_INTERVAL}
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat >/usr/lib/systemd/system/brew-upgrade.timer <<EOF
[Unit]
Description=Timer for brew upgrade for on image brew
Wants=network-online.target

[Timer]
OnBootSec=${WAIT_AFTER_BOOT_UPGRADE}
OnUnitInactiveSec=${UPGRADE_INTERVAL}
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Copy shell configuration files
cp -r "${MODULE_DIRECTORY}"/brew/brew-fish-completions.fish /usr/share/fish/vendor_conf.d/brew-fish-completions.fish
cp -r "${MODULE_DIRECTORY}"/brew/brew-bash-completions.sh /etc/profile.d/brew-bash-completions.sh

# Register path symlink
# We do this via tmpfiles.d so that it is created by the live system.
cat >/usr/lib/tmpfiles.d/homebrew.conf <<EOF
d /var/lib/homebrew 0755 1000 1000 - -
d /var/cache/homebrew 0755 1000 1000 - -
d /var/home/linuxbrew 0755 1000 1000 - -
EOF

# Enable the setup service
systemctl enable brew-setup.service

# Always enable or disable update and upgrade services for consistency
if [[ "${AUTO_UPDATE}" == true ]]; then
    systemctl enable brew-update.timer
else
    systemctl disable brew-update.timer
fi

if [[ "${AUTO_UPGRADE}" == true ]]; then
    systemctl enable brew-upgrade.timer
else
    systemctl disable brew-upgrade.timer
fi

# Apply nofile limits if enabled
if [[ "${NOFILE_LIMITS}" == true ]]; then

  if [[ -d "/etc/security/limits.d/" ]]; then
    readarray -t LIMITS_D_RESULTS < <(find /etc/security/limits.d/ -maxdepth 1 -type f -name '*.conf' -printf "%f\n")
  else
    LIMITS_D_RESULTS=()
  fi
  LIMITS_CONFIG="/etc/security/limits.conf"
  # Highest SystemD number location has the most preference.
  if [[ -d "/etc/systemd/user.conf.d/" ]]; then
    readarray -t SYSTEMD_USER_4 < <(find /etc/systemd/user.conf.d/ -maxdepth 1 -type f -name '*.conf' -printf "%f\n")
  else
    SYSTEMD_USER_4=()
  fi
  if [[ -d "/etc/systemd/system.conf.d/" ]]; then
    readarray -t SYSTEMD_SYS_4 < <(find /etc/systemd/system.conf.d/ -maxdepth 1 -type f -name '*.conf' -printf "%f\n")
  else
    SYSTEMD_SYS_4=()
  fi  
  SYSTEMD_USER_3="/etc/systemd/user.conf"
  SYSTEMD_SYS_3="/etc/systemd/system.conf"
  if [[ -d "/usr/lib/systemd/user.conf.d/" ]]; then  
    readarray -t SYSTEMD_USER_2 < <(find /usr/lib/systemd/user.conf.d/ -maxdepth 1 -type f -name '*.conf' -printf "%f\n")
  else
    SYSTEMD_USER_2=()
  fi
  if [[ -d "/usr/lib/systemd/system.conf.d/" ]]; then    
    readarray -t SYSTEMD_SYS_2 < <(find /usr/lib/systemd/system.conf.d/ -maxdepth 1 -type f -name '*.conf' -printf "%f\n")
  else
    SYSTEMD_SYS_2=()
  fi  
  SYSTEMD_USER_1="/usr/lib/systemd/system.conf"
  SYSTEMD_SYS_1="/usr/lib/systemd/system.conf"

  # Determines which limits config should be used (MP = most preferred, LP = least preferred)
  if [[ -f "${LIMITS_CONFIG}" ]]; then
    CURRENT_ULIMIT_SOFT_LP=$(awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' /etc/security/limits.conf)
    CURRENT_ULIMIT_HARD_LP=$(awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' /etc/security/limits.conf)
  if [[ ${#LIMITS_D_RESULTS[@]} -gt 0 ]]; then
    CURRENT_ULIMIT_SOFT_MP=$(awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' /etc/security/limits.d/*)
    echo "CURRENT_ULIMIT_SOFT=${CURRENT_ULIMIT_SOFT}"
    CURRENT_ULIMIT_HARD_MP=$(awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' /etc/security/limits.d/*)
    echo "CURRENT_ULIMIT_HARD=${CURRENT_ULIMIT_HARD}"
  if [[ -n ${CURRENT_ULIMIT_SOFT_MP} ]]; then
    CURRENT_ULIMIT_SOFT=${CURRENT_ULIMIT_SOFT_MP}
  if [[ -n ${CURRENT_ULIMIT_HARD_MP} ]]; then
    CURRENT_ULIMIT_HARD=${CURRENT_ULIMIT_HARD_MP}
  if [[ -z ${CURRENT_ULIMIT_SOFT_MP} ]] && [[ -n ${CURRENT_ULIMIT_SOFT_LP} ]]; then
    CURRENT_ULIMIT_SOFT=${CURRENT_ULIMIT_SOFT_LP}
  if [[ -z ${CURRENT_ULIMIT_HARD_MP} ]] && [[ -n ${CURRENT_ULIMIT_SOFT_LP} ]]; then
    CURRENT_ULIMIT_HARD=${CURRENT_ULIMIT_HARD_LP}
  if [[ -z ${CURRENT_ULIMIT_SOFT_LP} ]]; then
    CURRENT_ULIMIT_SOFT=0
  if [[ -z ${CURRENT_ULIMIT_HARD_LP} ]]; then
    CURRENT_ULIMIT_HARD=0  
  fi
    
  # From most preferred to least preferred
  # Commented "DefaultLimitNOFILE" value is ignored
  if [[ ${#SYSTEMD_USER_4[@]} -gt 0 ]]; then
    CURRENT_SYSTEMD_USER_SOFT=$(cat /etc/systemd/user.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_USER_HARD=$(cat /etc/systemd/user.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_USER_SOFT_4=${CURRENT_SYSTEMD_USER_SOFT}"
    echo "CURRENT_SYSTEMD_USER_HARD_4=${CURRENT_SYSTEMD_USER_HARD}"
  else
    CURRENT_SYSTEMD_USER_SOFT=0
    CURRENT_SYSTEMD_USER_HARD=0
  fi
  if [[ ${#SYSTEMD_SYS_4[@]} -gt 0 ]]; then
    CURRENT_SYSTEMD_SYSTEM_SOFT=$(cat /etc/systemd/system.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_SYSTEM_HARD=$(cat /etc/systemd/system.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_SYSTEM_SOFT_4=${CURRENT_SYSTEMD_SYSTEM_SOFT}"
    echo "CURRENT_SYSTEMD_SYSTEM_HARD_4=${CURRENT_SYSTEMD_SYSTEM_HARD}"
  else
    CURRENT_SYSTEMD_SYSTEM_SOFT=0
    CURRENT_SYSTEMD_SYSTEM_HARD=0
  fi
  #
  if [[ ${#SYSTEMD_USER_4[@]}  -eq 0 ]] && [[ -f "${SYSTEMD_USER_3}" ]]; then
    CURRENT_SYSTEMD_USER_SOFT=$(cat "${SYSTEMD_USER_3}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_USER_HARD=$(cat "${SYSTEMD_USER_3}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_USER_SOFT_3=${CURRENT_SYSTEMD_USER_SOFT}"
    echo "CURRENT_SYSTEMD_USER_HARD_3=${CURRENT_SYSTEMD_USER_HARD}"
  else
    CURRENT_SYSTEMD_USER_SOFT=0
    CURRENT_SYSTEMD_USER_HARD=0
  fi
  if [[ ${#SYSTEMD_SYS_4[@]}  -eq 0 ]] && [[ -f "${SYSTEMD_SYS_3}" ]]; then
    CURRENT_SYSTEMD_SYSTEM_SOFT=$(cat "${SYSTEMD_SYS_3}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_SYSTEM_HARD=$(cat "${SYSTEMD_SYS_3}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_SYSTEM_SOFT_3=${CURRENT_SYSTEMD_SYSTEM_SOFT}"
    echo "CURRENT_SYSTEMD_SYSTEM_HARD_3=${CURRENT_SYSTEMD_SYSTEM_HARD}"
  else
    CURRENT_SYSTEMD_SYSTEM_SOFT=0
    CURRENT_SYSTEMD_SYSTEM_HARD=0
  fi
  #
  if [[ ${#SYSTEMD_USER_4[@]}  -eq 0 ]] && [[ ! -f "${SYSTEMD_USER_3}" ]] && [[ ${#SYSTEMD_USER_2[@]} -gt 0 ]]; then
    CURRENT_SYSTEMD_USER_SOFT=$(cat /usr/lib/systemd/user.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_USER_HARD=$(cat /usr/lib/systemd/user.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_USER_SOFT_2=${CURRENT_SYSTEMD_USER_SOFT}"
    echo "CURRENT_SYSTEMD_USER_HARD_2=${CURRENT_SYSTEMD_USER_HARD}"
  else
    CURRENT_SYSTEMD_USER_SOFT=0
    CURRENT_SYSTEMD_USER_HARD=0  
  fi
  if [[ ${#SYSTEMD_SYS_4[@]}  -eq 0 ]] && [[ ! -f "${SYSTEMD_SYS_3}" ]] && [[ ${#SYSTEMD_SYS_2[@]} -gt 0 ]]; then
    CURRENT_SYSTEMD_SYSTEM_SOFT=$(cat /usr/lib/systemd/system.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_SYSTEM_HARD=$(cat /usr/lib/systemd/system.conf.d/* | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_SYSTEM_SOFT_2=${CURRENT_SYSTEMD_SYSTEM_SOFT}"
    echo "CURRENT_SYSTEMD_SYSTEM_HARD_2=${CURRENT_SYSTEMD_SYSTEM_HARD}"
  else
    CURRENT_SYSTEMD_SYSTEM_SOFT=0
    CURRENT_SYSTEMD_SYSTEM_HARD=0 
  fi
  #
  if [[ ${#SYSTEMD_USER_4[@]}  -eq 0 ]] && [[ ! -f "${SYSTEMD_USER_3}" ]] && [[ ${#SYSTEMD_USER_2[@]} -eq 0 ]] && [[ -f "${SYSTEMD_USER_1}" ]]; then
    CURRENT_SYSTEMD_USER_SOFT=$(cat "${SYSTEMD_USER_1}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_USER_HARD=$(cat "${SYSTEMD_USER_1}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_USER_SOFT_1=${CURRENT_SYSTEMD_USER_SOFT}"
    echo "CURRENT_SYSTEMD_USER_HARD_1=${CURRENT_SYSTEMD_USER_HARD}"
  else
    CURRENT_SYSTEMD_USER_SOFT=0
    CURRENT_SYSTEMD_USER_HARD=0
  fi
  if [[ ${#SYSTEMD_SYS_4[@]}  -eq 0 ]] && [[ ! -f "${SYSTEMD_SYS_3}" ]] && [[ ${#SYSTEMD_SYS_2[@]} -eq 0 ]] && [[ -f "${SYSTEMD_SYS_1}" ]]; then
    CURRENT_SYSTEMD_SYSTEM_SOFT=$(cat "${SYSTEMD_SYS_1}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
    CURRENT_SYSTEMD_SYSTEM_HARD=$(cat "${SYSTEMD_SYS_1}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
    echo "CURRENT_SYSTEMD_SYSTEM_SOFT_1=${CURRENT_SYSTEMD_SYSTEM_SOFT}"
    echo "CURRENT_SYSTEMD_SYSTEM_HARD_1=${CURRENT_SYSTEMD_SYSTEM_HARD}"
  else
    CURRENT_SYSTEMD_SYSTEM_SOFT=0
    CURRENT_SYSTEMD_SYSTEM_HARD=0
  fi

  echo "Applying nofile limits..."
    
  if [[ ! -d "/usr/etc/security/limits.d/" ]]; then
    mkdir -p "/usr/etc/security/limits.d/"
  fi
  if [[ ${CURRENT_ULIMIT_SOFT} -lt 4096 ]] || [[ ${CURRENT_ULIMIT_HARD} -lt 524288 ]]; then
    cat >/usr/etc/security/limits.d/zz1-brew-limits.conf > /dev/null <<EOF
# This file sets the resource limits for users logged in via PAM,
# more specifically, users logged in via SSH or tty (console).
# Limits related to terminals in Wayland/Xorg sessions depend on a
# change to /etc/systemd/user.conf.
# This does not affect resource limits of the system services.
# This file overrides defaults set in /etc/security/limits.conf

EOF
  fi
  if [[ ${CURRENT_ULIMIT_SOFT} -lt 4096 ]]; then
    echo "Writing soft nofile limit for SSH/TTY sessions"  
    echo "* soft nofile 4096" >> /usr/etc/security/limits.d/zz1-brew-limits.conf
  fi  
  if [[ ${CURRENT_ULIMIT_HARD} -lt 524288 ]]; then
    echo "Writing hard nofile limit for SSH/TTY sessions"
    echo "* hard nofile 524288" >> /usr/etc/security/limits.d/zz1-brew-limits.conf
  fi
    
  if [[ ${CURRENT_SYSTEMD_SYSTEM_SOFT} -lt 4096 ]] && [[ ${CURRENT_SYSTEMD_SYSTEM_HARD} -lt 524288 ]]; then
    echo "Writing soft & hard nofile limit for DE session using SystemD"
    cat >/usr/etc/systemd/system/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:524288
EOF
  fi
  
  if [[ ${CURRENT_SYSTEMD_SYSTEM_SOFT} -lt 4096 ]]; then
    echo "Writing soft nofile limit for DE sessions using SystemD"    
    cat >/usr/etc/systemd/system/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:${CURRENT_SYSTEMD_USER_HARD}
EOF
  fi

  if [[ ${CURRENT_SYSTEMD_SYSTEM_HARD} -lt 524288 ]]; then
    echo "Writing hard & soft nofile limit for DE sessionsusing SystemD"
    cat >/usr/etc/systemd/system/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=${CURRENT_SYSTEMD_USER_SOFT}:524288
EOF
  fi

# Disable homebrew analytics if the flag is set to false
# like secureblue: https://github.com/secureblue/secureblue/blob/live/config/scripts/homebrewanalyticsoptout.sh
if [[ "${BREW_ANALYTICS}" == false ]]; then
    echo "HOMEBREW_NO_ANALYTICS=1" >> /usr/etc/environment
fi

# Install specified Brew packages if any
if [[ "${#PACKAGE_LIST[@]}" -gt 0 ]]; then
    echo "Installing specified Brew packages..."
    su -c "/home/linuxbrew/.linuxbrew/bin/brew install ${PACKAGE_LIST[*]}" -s /bin/bash linuxbrew
else
    echo "No Brew packages specified for installation."
fi

echo "Brew setup completed."
