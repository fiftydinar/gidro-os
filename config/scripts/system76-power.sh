#!/usr/bin/env bash
set -oue pipefail

systemctl mask power-profiles-daemon.service
