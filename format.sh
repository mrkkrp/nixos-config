#!/usr/bin/env bash

nixpkgs-fmt $(find devices imports -type f -name "*.nix") flake.nix
