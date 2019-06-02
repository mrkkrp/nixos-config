#!/usr/bin/env bash
#
# Configure stack

set -euo pipefail

mkdir -p ~/.stack
cp -v files/.stack/config.yaml ~/.stack/config.yaml
