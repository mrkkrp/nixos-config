pkgs:

let
  mkConfig = epkgs: epkgs.trivialBuild {
    pname = "mk-config";
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
      counsel
      cyphejor
      direnv
      f
      fish-mode
      fix-input
      fix-word
      flycheck
      flycheck-color-mode-line
      flycheck-mmark
      flyspell-lazy
      git-link
      gitignore-mode
      haskell-mode
      highlight-symbol
      hl-todo
      ivy
      js2-mode
      kill-or-bury-alive
      lsp-haskell
      lsp-mode
      lsp-ui
      magit
      markdown-mode
      modalka
      mustache-mode
      nix-mode
      proof-general
      rainbow-delimiters
      rich-minority
      ripgrep
      rust-mode
      smart-mode-line
      smartparens
      swiper
      terraform-mode
      tuareg
      typit
      use-package
      visual-regexp
      whole-line-or-region
      yaml-mode
      yasnippet
      zenburn-theme
      ztree
      zygospore
      zzz-to-char
    ];
  };
in pkgs.emacs27WithPackages (epkgs: [(mkConfig epkgs)])
