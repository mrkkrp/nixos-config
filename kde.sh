#!/usr/bin/env bash
#
# Configure KDE

set -e

echo "This is not automated (yet):"

echo "1. Setup hotkeys (automatic)."
cp -v files/.config/khotkeysrc ~/.config/khotkeysrc
echo "2. Enable sticky keys."
echo "3. Speed of key repeat (delay=600, speed=50 per second)."
echo "4. Dolphin should show hidden files."
echo "5. Enable compose key (keyboard -> advanced -> position of compose key)."
