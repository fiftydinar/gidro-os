#!/usr/bin/env bash

set -oue pipefail

sudo rpm-ostree kargs --append='radeon.cik_support=0 amdgpu.cik_support=1 radeon.si_support=0 amdgpu.si_support=1 amd_pstate=active'
