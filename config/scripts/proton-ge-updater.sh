#!/usr/bin/env bash

set -oue pipefail

systemctl enable --global proton-ge-updater.service
