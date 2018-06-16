#!/usr/bin/env bash
#
# Create project directory tree and clone some repos

set -e

# Coq
mkdir -pv ~/projects/programs/coq && cd ~/projects/programs/coq
git clone git@github.com:mrkkrp/software-foundations.git

# Emacs Lisp

mkdir -pv ~/projects/programs/emacs-lisp && cd ~/projects/programs/emacs-lisp
git clone git@github.com:mrkkrp/ace-popup-menu.git
git clone git@github.com:mrkkrp/avy-menu.git
git clone git@github.com:mrkkrp/char-menu.git
git clone git@github.com:mrkkrp/common-lisp-snippets.git
git clone git@github.com:mrkkrp/cyphejor.git
git clone git@github.com:mrkkrp/fix-input.git
git clone git@github.com:mrkkrp/fix-word.git
git clone git@github.com:mrkkrp/kill-or-bury-alive.git
git clone git@github.com:mrkkrp/mmt.git
git clone git@github.com:mrkkrp/modalka.git
git clone git@github.com:mrkkrp/typit.git
git clone git@github.com:mrkkrp/vimish-fold.git
git clone git@github.com:mrkkrp/zzz-to-char.git

# Haskell

mkdir -pv ~/projects/programs/haskell && cd ~/projects/programs/haskell
git clone git@github.com:commercialhaskell/path.git
git clone git@github.com:mrkkrp/JuicyPixels-extra.git
git clone git@github.com:mrkkrp/cue-sheet.git
git clone git@github.com:mrkkrp/facts.git
git clone git@github.com:mrkkrp/flac-picture.git
git clone git@github.com:mrkkrp/flac.git
git clone git@github.com:mrkkrp/forma.git
git clone git@github.com:mrkkrp/ghc-syntax-highlighter.git
git clone git@github.com:mrkkrp/hspec-megaparsec.git
git clone git@github.com:mrkkrp/htaglib.git
git clone git@github.com:mrkkrp/html-entity-map-gen.git
git clone git@github.com:mrkkrp/html-entity-map.git
git clone git@github.com:mrkkrp/identicon.git
git clone git@github.com:mrkkrp/imprint.git
git clone git@github.com:mrkkrp/lame.git
git clone git@github.com:mrkkrp/markkarpov.com.git
git clone git@github.com:mrkkrp/megaparsec.git
git clone git@github.com:mrkkrp/modern-uri.git
git clone git@github.com:mrkkrp/pagination.git
git clone git@github.com:mrkkrp/parser-combinators.git
git clone git@github.com:mrkkrp/path-io.git
git clone git@github.com:mrkkrp/req-conduit.git
git clone git@github.com:mrkkrp/req.git
git clone git@github.com:mrkkrp/slug.git
git clone git@github.com:mrkkrp/tagged-identity.git
git clone git@github.com:mrkkrp/text-metrics.git
git clone git@github.com:mrkkrp/wave.git
git clone git@github.com:mrkkrp/zip.git
git clone git@github.com:stackbuilders/cassava-megaparsec.git
git clone git@github.com:stackbuilders/stache.git

# Hasky mode

mkdir -pv ~/projects/programs/hasky-mode && cd ~/projects/programs/hasky-mode
git clone git@github.com:hasky-mode/hasky-cabal.git
git clone git@github.com:hasky-mode/hasky-extensions.git
git clone git@github.com:hasky-mode/hasky-stack.git

# MMark

mkdir -pv ~/projects/programs/mmark && cd ~/projects/programs/mmark
git clone git@github.com:mmark-md/flycheck-mmark.git
git clone git@github.com:mmark-md/mmark.git
git clone git@github.com:mmark-md/mmark-cli.git
git clone git@github.com:mmark-md/mmark-ext.git
