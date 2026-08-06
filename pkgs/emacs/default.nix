pkgs:

let
  # The nushell-ts-mode in nixpkgs is a stale MELPA snapshot (2023) whose
  # font-lock queries are incompatible with the current tree-sitter-nu
  # grammar, so build it from upstream instead.  Upstream tracks the modern
  # grammar (fixes merged 2026-07-05).
  nushell-ts-mode = epkgs: epkgs.trivialBuild {
    pname = "nushell-ts-mode";
    version = "unstable-2026-07-05";
    src = pkgs.fetchFromGitHub {
      owner = "herbertjones";
      repo = "nushell-ts-mode";
      rev = "49915cd99d62b7e743bd8cf9023a5819479d166f";
      hash = "sha256-QgBHTUsNOiGM9NojEPjBhORDttL8kGwgdvsqRYOVqa4=";
    };
  };
  mkConfig = epkgs: epkgs.trivialBuild {
    pname = "mk-config";
    version = "0.0.0.0";
    src = pkgs.lib.sourceByRegex ./. [
      "^.*\.el$"
    ];
    packageRequires = with epkgs; [
      ace-link
      ace-popup-menu
      ace-window
      aggressive-indent
      avy
      avy-menu
      char-menu
      consult
      cyphejor
      dumb-jump
      embark
      embark-consult
      envrc
      f
      fd-dired
      fix-input
      fix-word
      flycheck
      flycheck-color-mode-line
      flycheck-lilypond
      flycheck-mmark
      git-link
      git-modes
      haskell-mode
      hl-todo
      kill-or-bury-alive
      magit
      marginalia
      markdown-mode
      minions
      modalka
      mustache-mode
      nix-ts-mode
      (nushell-ts-mode epkgs)
      orderless
      prescient
      proof-general
      protobuf-mode
      rainbow-delimiters
      smart-mode-line
      smartparens
      symbol-overlay
      treesit-grammars.with-all-grammars
      vertico
      vertico-prescient
      visual-replace
      whole-line-or-region
      zenburn-theme
      ztree
      zygospore
      zzz-to-char
    ];
  };
in
pkgs.emacs30.pkgs.withPackages (epkgs: [ (mkConfig epkgs) ])
