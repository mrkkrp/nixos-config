pkgs:

let
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
      nushell-mode
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
