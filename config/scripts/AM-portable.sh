#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && ./INSTALL
