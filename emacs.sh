#!/usr/bin/env bash
#
# Configure Emacs

set -e

git clone git@github.com:mrkkrp/dot-emacs.git ~/.emacs.d
git clone git@github.com:ProofGeneral/PG.git ~/.emacs.d/proof-general
cd ~/.emacs.d && python test-startup.py
