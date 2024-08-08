#!/usr/bin/env bash

set -euo pipefail

touch /etc/hosts
wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts -O /etc/hosts
