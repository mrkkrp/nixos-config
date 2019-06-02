#!/usr/bin/env bash
#
# Configure Emacs

set -euo pipefail

git clone git@github.com:mrkkrp/dot-emacs.git ~/.emacs.d
cd ~/.emacs.d && python test-startup.py
