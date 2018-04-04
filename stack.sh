#!/usr/bin/env bash
#
# Configure stack

set -e

nix-env -iA nixos.stack
mkdir -p ~/.stack
cp -v files/.stack/config.yaml ~/.stack/config.yaml
