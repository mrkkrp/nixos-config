#!/usr/bin/env bash
#
# Misc config

set -euo pipefail

mkdir -pv ~/.nixpkgs
cp -v files/.nixpkgs/config.nix ~/.nixpkgs/config.nix
