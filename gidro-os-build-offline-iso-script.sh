#!/usr/bin/env bash

ARCH=x86_64
VERSION=39
IMAGE_REPO=ghcr.io/fiftydinar
IMAGE_NAME=gidro-os
IMAGE_TAG=latest
EXTRA_BOOT_PARAMS=""
VARIANT=Kinoite
WEB_UI=false
ENROLLMENT_PASSWORD=ublue-os
SECURE_BOOT_KEY_URL=https://github.com/ublue-os/akmods/raw/main/certs/public_key.der

sudo podman run --rm --privileged --volume .:/isogenerator/output --security-opt label=disable --pull=newer \
-e ARCH="$ARCH" -e VERSION="$VERSION" -e IMAGE_REPO="$IMAGE_REPO" -e IMAGE_NAME="$IMAGE_NAME" -e IMAGE_TAG="$IMAGE_TAG" \
-e VARIANT="$VARIANT" -e WEB_UI="$WEB_UI" -e ENROLLMENT_PASSWORD="$ENROLLMENT_PASSWORD" -e SECURE_BOOT_KEY_URL="$SECURE_BOOT_KEY_URL" \
ghcr.io/ublue-os/isogenerator:$VERSION
