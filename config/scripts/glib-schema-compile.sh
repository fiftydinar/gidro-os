#!/usr/bin/env bash

set -euo pipefail

mkdir -p /tmp/gidro-schema-test
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/gidro-schema-test/ \;
cp /usr/share/glib-2.0/schemas/zzz-gidro.gschema.override /tmp/gidro-schema-test/
echo "Running error test for gidro gschema override. Aborting if failed."
glib-compile-schemas --strict /tmp/gidro-schema-test
echo "Compiling gschema to include gidro setting overrides"
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null
rm -rf /tmp/gidro-schema-test
