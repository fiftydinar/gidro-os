#!/usr/bin/env bash

set -oue pipefail

wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts -O /usr/etc/hosts
chmod 0440 /usr/etc/hosts
