#!/usr/bin/env bash

set -euo pipefail

echo "" > /etc/hosts
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts -O /etc/hosts
