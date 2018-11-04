#!/usr/bin/env bash
#
# Configure Agda

set -e

AGDA_STDLIB=$(nix eval --raw nixpkgs.AgdaStdlib.out.outPath)

mkdir -pv ~/.agda/

echo "standard-library" > ~/.agda/defaults
echo "$HOME/.agda/standard-library.agda-lib" > ~/.agda/libraries
echo "name: standard-library" > ~/.agda/standard-library.agda-lib
echo "include: $AGDA_STDLIB/share/agda" >> ~/.agda/standard-library.agda-lib
