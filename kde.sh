#!/usr/bin/env bash
#
# Configure KDE

set -euo pipefail

echo "Not all operations here are atomatic yet:"

echo "1. Setup hotkeys (automatic)."
cp -v files/.config/khotkeysrc ~/.config/khotkeysrc
echo "2. Dolphin should show hidden files."
