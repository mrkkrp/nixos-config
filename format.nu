#!/usr/bin/env nu

nixpkgs-fmt (ls **/*.nix | get name)
