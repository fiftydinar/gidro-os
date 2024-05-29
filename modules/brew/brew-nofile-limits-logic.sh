#!/usr/bin/env bash

set -euo pipefail

# Script used to read nofile limits from the base image, since issuing easy systemctl status commands don't work in build-time.
# Takes into account config priorities & current config settings regarding nofile limits
# (if nofile limit is already applied with appropriate values in the base image, than this tweak is not applied)
# Modifies limits nofile value & systemd DefaultLimitNOFILE value

# SSH/TTY limit (security ulimit config)

LIMITS_FILE=("/etc/security/limits.conf" "/usr/etc/security/limits.conf")
LIMITS_D_DIR=("/etc/security/limits.d/" "/usr/etc/security/limits.d/")

# SSH/TTY soft limit
security_limits_soft=0

if [[ -f "${LIMITS_FILE[1]}" ]]; then
  security_limits_soft=$(awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' "${LIMITS_FILE[1]}")
  if [[ -z "${security_limits_soft}" ]]; then
    security_limits_soft=0
  fi  
fi

if [[ -d "${LIMITS_D_DIR[1]}" ]] && [[ "${security_limits_soft}" == 0 ]]; then
  security_limits_soft=$(find "${LIMITS_D_DIR[1]}" -type f -name "*.conf" -exec awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' {} + | tail -n 1)
  if [[ -z "${security_limits_soft}" ]]; then
    security_limits_soft=0
  fi  
fi

if [[ -f "${LIMITS_FILE[0]}" ]] && [[ "${security_limits_soft}" == 0 ]]; then
  security_limits_soft=$(awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' "${LIMITS_FILE[0]}")
  if [[ -z "${security_limits_soft}" ]]; then
    security_limits_soft=0
  fi  
fi

if [[ -d "${LIMITS_D_DIR[0]}" ]] && [[ "${security_limits_soft}" == 0 ]]; then
  security_limits_soft=$(find "${LIMITS_D_DIR[0]}" -type f -name "*.conf" -exec awk '/soft\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' {} + | tail -n 1)
  if [[ -z "${security_limits_soft}" ]]; then
    security_limits_soft=0
  fi  
fi

# SSH/TTY hard limit
security_limits_hard=0

if [[ -f "${LIMITS_FILE[1]}" ]]; then
  security_limits_hard=$(awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' "${LIMITS_FILE[1]}")
  if [[ -z "${security_limits_hard}" ]]; then
    security_limits_hard=0
  fi  
fi

if [[ -d "${LIMITS_D_DIR[1]}" ]] && [[ "${security_limits_hard}" == 0 ]]; then
  security_limits_hard=$(find "${LIMITS_D_DIR[1]}" -type f -name "*.conf" -exec awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' {} + | tail -n 1)
  if [[ -z "${security_limits_hard}" ]]; then
    security_limits_hard=0
  fi  
fi

if [[ -f "${LIMITS_FILE[0]}" ]] && [[ "${security_limits_hard}" == 0 ]]; then
  security_limits_hard=$(awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' "${LIMITS_FILE[0]}")
  if [[ -z "${security_limits_hard}" ]]; then
    security_limits_hard=0
  fi  
fi

if [[ -d "${LIMITS_D_DIR[0]}" ]] && [[ "${security_limits_hard}" == 0 ]]; then
  security_limits_hard=$(find "${LIMITS_D_DIR[0]}" -type f -name "*.conf" -exec awk '/hard\s+nofile/ && !/^#/ {sub(/.*nofile/, ""); gsub(/^[ \t]+/, ""); print}' {} + | tail -n 1)
  if [[ -z "${security_limits_hard}" ]]; then
    security_limits_hard=0
  fi  
fi

# SystemD system limit

SYSTEMD_SYS_DIR=("/etc/systemd/system.conf.d/" "/usr/etc/systemd/system.conf.d/" "/usr/lib/systemd/system.conf.d/")
SYSTEMD_SYS_FILE=("/etc/systemd/system.conf" "/usr/etc/systemd/system.conf" "/usr/lib/systemd/system.conf")

# SystemD system soft limit
systemd_sys_soft=0

if [[ -f "${SYSTEMD_SYS_FILE[2]}" ]]; then
  systemd_sys_soft=$(cat "${SYSTEMD_SYS_FILE[2]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[2]}" ]] && [[ "${systemd_sys_soft}" == 0 ]]; then
  systemd_sys_soft=$(find "${SYSTEMD_SYS_DIR[2]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

if [[ -f "${SYSTEMD_SYS_FILE[1]}" ]]; then
  systemd_sys_soft=$(cat "${SYSTEMD_SYS_FILE[1]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[1]}" ]] && [[ "${systemd_sys_soft}" == 0 ]]; then
  systemd_sys_soft=$(find "${SYSTEMD_SYS_DIR[1]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

if [[ -f "${SYSTEMD_SYS_FILE[0]}" ]] && [[ "${systemd_sys_soft}" == 0 ]]; then
  systemd_sys_soft=$(cat "${SYSTEMD_SYS_FILE[0]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[0]}" ]] && [[ "${systemd_sys_soft}" == 0 ]]; then
  systemd_sys_soft=$(find "${SYSTEMD_SYS_DIR[0]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_soft}" ]]; then
    systemd_sys_soft=0
  fi  
fi

# SystemD system hard limit

systemd_sys_hard=0

if [[ -f "${SYSTEMD_SYS_FILE[2]}" ]]; then
  systemd_sys_hard=$(cat "${SYSTEMD_SYS_FILE[2]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[2]}" ]] && [[ "${systemd_sys_hard}" == 0 ]]; then
  systemd_sys_hard=$(find "${SYSTEMD_SYS_DIR[2]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi

if [[ -f "${SYSTEMD_SYS_FILE[1]}" ]]; then
  systemd_sys_hard=$(cat "${SYSTEMD_SYS_FILE[1]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[1]}" ]] && [[ "${systemd_sys_hard}" == 0 ]]; then
  systemd_sys_hard=$(find "${SYSTEMD_SYS_DIR[1]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi


if [[ -f "${SYSTEMD_SYS_FILE[0]}" ]] && [[ "${systemd_sys_hard}" == 0 ]]; then
  systemd_sys_hard=$(cat "${SYSTEMD_SYS_FILE[0]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_SYS_DIR[0]}" ]] && [[ "${systemd_sys_hard}" == 0 ]]; then
  systemd_sys_hard=$(find "${SYSTEMD_SYS_DIR[0]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_sys_hard}" ]]; then
    systemd_sys_hard=0
  fi  
fi

# SystemD user limit
SYSTEMD_USER_DIR=("/etc/systemd/user.conf.d/" "/usr/etc/systemd/user.conf.d/" "/usr/lib/systemd/user.conf.d/")
SYSTEMD_USER_FILE=("/etc/systemd/user.conf" "/usr/etc/systemd/user.conf" "/usr/lib/systemd/user.conf")

# SystemD user soft limit

systemd_user_soft=0

if [[ -f "${SYSTEMD_USER_FILE[2]}" ]]; then
  systemd_user_soft=$(cat "${SYSTEMD_USER_FILE[2]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[2]}" ]] && [[ "${systemd_user_soft}" == 0 ]]; then
  systemd_user_soft=$(find "${SYSTEMD_USER_DIR[2]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

if [[ -f "${SYSTEMD_USER_FILE[1]}" ]]; then
  systemd_user_soft=$(cat "${SYSTEMD_USER_FILE[1]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[1]}" ]] && [[ "${systemd_user_soft}" == 0 ]]; then
  systemd_user_soft=$(find "${SYSTEMD_USER_DIR[1]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

if [[ -f "${SYSTEMD_USER_FILE[0]}" ]] && [[ "${systemd_user_soft}" == 0 ]]; then
  systemd_user_soft=$(cat "${SYSTEMD_USER_FILE[0]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}')
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[0]}" ]] && [[ "${systemd_user_soft}" == 0 ]]; then
  systemd_user_soft=$(find "${SYSTEMD_USER_DIR[0]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $2}' {} + | tail -n 1)
  if [[ -z "${systemd_user_soft}" ]]; then
    systemd_user_soft=0
  fi  
fi

# SystemD user hard limit

systemd_user_hard=0

if [[ -f "${SYSTEMD_USER_FILE[2]}" ]]; then
  systemd_user_hard=$(cat "${SYSTEMD_USER_FILE[2]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[2]}" ]] && [[ "${systemd_user_hard}" == 0 ]]; then
  systemd_user_hard=$(find "${SYSTEMD_USER_DIR[2]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

if [[ -f "${SYSTEMD_USER_FILE[1]}" ]]; then
  systemd_user_hard=$(cat "${SYSTEMD_USER_FILE[1]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[1]}" ]] && [[ "${systemd_user_hard}" == 0 ]]; then
  systemd_user_hard=$(find "${SYSTEMD_USER_DIR[1]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

if [[ -f "${SYSTEMD_USER_FILE[0]}" ]] && [[ "${systemd_user_hard}" == 0 ]]; then
  systemd_user_hard=$(cat "${SYSTEMD_USER_FILE[0]}" | awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}')
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

if [[ -d "${SYSTEMD_USER_DIR[0]}" ]] && [[ "${systemd_user_hard}" == 0 ]]; then
  systemd_user_hard=$(find "${SYSTEMD_USER_DIR[0]}" -type f -name "*.conf" -exec awk -F'[:=]' '/^[^#]*DefaultLimitNOFILE/ {print $3}' {} + | tail -n 1)
  if [[ -z "${systemd_user_hard}" ]]; then
    systemd_user_hard=0
  fi  
fi

limits_inform() {
if [[ "${security_limits_soft}" == 0 ]]; then
  echo "SSH/TTY soft limit: UNSET!"
else
  echo "SSH/TTY soft limit: ${security_limits_soft}"
fi

if [[ "${security_limits_hard}" == 0 ]]; then
  echo "SSH/TTY hard limit: UNSET!"
else
  echo "SSH/TTY hard limit: ${security_limits_hard}"
fi

if [[ "${systemd_sys_soft}" == 0 ]]; then
  echo "SystemD system soft limit: UNSET!"
else
  echo "SystemD system soft limit: ${systemd_sys_soft}"
fi

if [[ "${systemd_sys_hard}" == 0 ]]; then
  echo "SystemD system hard limit: UNSET!"
else
  echo "SystemD system hard limit: ${systemd_sys_hard}"
fi

if [[ "${systemd_user_soft}" == 0 ]]; then
  echo "SystemD user soft limit: UNSET!"
else
  echo "SystemD user soft limit: ${systemd_user_soft}"
fi

if [[ "${systemd_user_hard}" == 0 ]]; then
  echo "SystemD user hard limit: UNSET!"
else
  echo "SystemD user hard limit: ${systemd_user_hard}"
fi
}

# Inform the user about the current nofile limit values in the base image
echo "Current unmodified nofile values in the base image:"
echo
limits_inform

# Apply the values

# Security limits.d
if [[ "${security_limits_soft}" -lt 4096 ]] || [[ "${security_limits_hard}" -lt 524288 ]]; then
  if [[ ! -d "/usr/etc/security/limits.d/" ]]; then
    mkdir -p "/usr/etc/security/limits.d/"
  fi
  cat >/usr/etc/security/limits.d/zz1-brew-limits.conf > /dev/null <<EOF
# This file sets the resource limits for users logged in via PAM,
# more specifically, users logged in via SSH or tty (console).
# Limits related to terminals in Wayland/Xorg sessions depend on a
# change to /etc/systemd/user.conf.
# This does not affect resource limits of the system services.
# This file overrides defaults set in /etc/security/limits.conf

EOF
fi

if [[ ${security_limits_soft} -lt 4096 ]]; then
  echo "Writing soft nofile limit for SSH/TTY sessions"  
  if [[ ! -d "/usr/etc/security/limits.d/" ]]; then
    mkdir -p "/usr/etc/security/limits.d/"
  fi
  if [[ ! -f "/usr/etc/security/limits.d/zz1-brew-limits.conf" ]]; then
    echo "" > "/usr/etc/security/limits.d/zz1-brew-limits.conf"
  fi
  echo "* soft nofile 4096" >> /usr/etc/security/limits.d/zz1-brew-limits.conf
fi  
if [[ ${security_limits_hard} -lt 524288 ]]; then
  echo "Writing hard nofile limit for SSH/TTY sessions"
  if [[ ! -d "/usr/etc/security/limits.d/" ]]; then
    mkdir -p "/usr/etc/security/limits.d/"
  fi    
  if [[ ! -f "/usr/etc/security/limits.d/zz1-brew-limits.conf" ]]; then
    echo "" > "/usr/etc/security/limits.d/zz1-brew-limits.conf"
  fi
  echo "* hard nofile 524288" > /usr/etc/security/limits.d/zz1-brew-limits.conf
fi

# Systemd system soft limit
if [[ "${systemd_sys_soft}" -lt 4096 ]] && [[ ${systemd_sys_hard} -ge 524288 ]]; then
  echo "Writing 'system' soft nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/system.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/system.conf.d/"
  fi    
  if [[ ! -f "/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf" ]]; then  
  cat >/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:${systemd_sys_hard}
EOF
  fi
fi

# Systemd system hard limit
if [[ "${systemd_sys_soft}" -ge 4096 ]] && [[ ${systemd_sys_hard} -lt 524288 ]]; then
  echo "Writing 'system' hard nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/system.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/system.conf.d/"
  fi    
  if [[ ! -f "/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf" ]]; then  
  cat >/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=${systemd_sys_soft}:524288
EOF
  fi
fi

# Systemd system soft & hard limit
if [[ "${systemd_sys_soft}" -lt 4096 ]] && [[ ${systemd_sys_hard} -lt 524288 ]]; then
  echo "Writing 'system' soft & hard nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/system.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/system.conf.d/"
  fi    
    if [[ ! -f "/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf" ]]; then   
  cat >/usr/etc/systemd/system.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:524288
EOF
    fi
fi

# Systemd user soft limit
if [[ "${systemd_user_soft}" -lt 4096 ]] && [[ ${systemd_user_hard} -ge 524288 ]]; then
  echo "Writing 'user' soft nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/user.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/user.conf.d/"
  fi  
  if [[ ! -f "/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf" ]]; then     
  cat >/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:${systemd_sys_hard}
EOF
  fi
fi

# Systemd user hard limit
if [[ "${systemd_user_soft}" -ge 4096 ]] && [[ ${systemd_user_hard} -lt 524288 ]]; then
  echo "Writing 'user' hard nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/user.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/user.conf.d/"
  fi
  if [[ ! -f "/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf" ]]; then       
  cat >/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=${systemd_sys_soft}:524288
EOF
  fi
fi

# Systemd user soft & hard limit
if [[ "${systemd_user_soft}" -lt 4096 ]] && [[ ${systemd_user_hard} -lt 524288 ]]; then
  echo "Writing 'user' soft & hard nofile limit for DE sessions using SystemD"
  if [[ ! -d "/usr/etc/systemd/user.conf.d/" ]]; then
    mkdir -p "/usr/etc/systemd/user.conf.d/"
  fi
  if [[ ! -f "/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf" ]]; then         
  cat >/usr/etc/systemd/user.conf.d/zz1-brew-limits.conf > /dev/null <<EOF
[Manager]
DefaultLimitNOFILE=4096:524288
EOF
  fi
fi

echo "Modified nofile values in the base image:"
echo
limits_inform
