#!/usr/bin/env bash

set -oue pipefail

rpm-ostree kargs --append=radeon.si_support=0,radeon.cik_support=0
