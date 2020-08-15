# These are the options which are shared between all configurations/devices.
{ config, pkgs, ... }:
{
  system.stateVersion = "19.09";

  imports = [
    ./symlinks/activation-script.nix
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    networkmanager.enable = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command
    '';
  };

  nixpkgs = {
    system = "x86_64-linux";
    config = {
      pulseaudio = true;
      allowUnfree = true;
    };
    overlays = [
      (import ./overlay.nix)
    ];
  };

  services.ntp.enable = true;
  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };
  virtualisation.docker.enable = true;
  programs.gnupg.agent.enable = true;

  environment = {
    systemPackages = with pkgs; [
      autoconf
      automake
      binutils
      bzip2
      coreutils
      diffutils
      dosfstools
      e2fsprogs
      eject
      emacs
      fd
      file
      findutils
      gcc
      gdb
      glibc
      gnugrep
      gnumake
      gnupg
      gnused
      gnutar
      gnutls
      groff
      htop
      inetutils
      killall
      less
      libtool
      man
      man-pages
      nano
      networkmanager
      nginxMainline
      nixops
      ntfs3g
      ntp
      openssl
      openvpn
      patch
      pavucontrol
      pulseaudioFull
      python3Full
      ripgrep
      ruby
      sudo
      unzip
      vim
      wget
      which
      zip
    ];
  };

  security.sudo.enable = true;
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.bash;

  users.users.mark = {
    isNormalUser = true;
    createHome = true;
    description = "Mark Karpov";
    uid = 1000;
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    hashedPassword = "$6$rBDWl6/g.dgUp$l6fYq.V1jzQRzsY9o6hSqsB77XAWVjSTLmcrzbjW7zl9DvNeO2LfjOHEOzH7j9Mr1WFofl6FO3CkyITN/UzRp0";
    packages = with pkgs; [
      (import ./emacs pkgs)
      (wine.override { wineBuild = "wineWow"; })
      alsaLib
      alsaOss
      alsaPlugins
      alsaTools
      alsaUtils
      bazel
      cabal-install
      cargo
      coq
      darktable
      direnv
      docker
      docker-compose
      fish
      flac
      gimp
      git
      git-lfs
      google-chrome
      google-cloud-sdk
      haskellPackages.ghcid
      haskellPackages.haskell-language-server
      haskellPackages.hasktags
      haskellPackages.hlint
      haskellPackages.mmark-cli
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.fr-moderne
      hunspellDicts.ru-ru
      inkscape
      inotify-tools
      mupdf
      ocaml
      opam
      openconnect
      postgresql
      pwsafe
      qbittorrent
      qiv
      rustc
      shellcheck
      stack
      tdesktop
      texlive.combined.scheme-full
      tmate
      virtualbox
      vlc
      wmctrl
      zoom-us
    ];
    shell = "${pkgs.fish}/bin/fish";

    symlinks = {
      ".config/kglobalshortcutsrc" = ./.config/kglobalshortcutsrc;
      ".config/khotkeysrc" = ./.config/khotkeysrc;
      ".config/konsolerc" = ./.config/konsolerc;
      ".config/kwinrulesrc" = ./.config/kwinrulesrc;
      ".emacs.d/init.el" = ./emacs/init.el;
      ".emacs.d/snippets" = ./emacs/snippets;
      ".gitconfig" = pkgs.gitconfig;
      ".nixpkgs/config.nix" = pkgs.nixconfig;
      ".stack/config.yaml" = pkgs.stackconfig;
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;

    desktopManager = {
      plasma5.enable = true;
    };

    displayManager = {
      sddm.enable = true;
      defaultSession = "plasma5";
      sessionCommands = ''
        export PATH=$HOME/.local/bin:$PATH
        kwriteconfig5 --file $HOME/.config/kaccessrc --group Keyboard --key StickyKeys --type bool true
        kwriteconfig5 --file $HOME/.config/kcminputrc --group Keyboard --key RepeatDelay 600
        kwriteconfig5 --file $HOME/.config/kcminputrc --group Keyboard --key RepeatRate 50
        kwriteconfig5 --file $HOME/.config/kxkbrc --group Layout --key Options "terminate:ctrl_alt_bksp,compose:sclk"
        kwriteconfig5 --file $HOME/.config/kxkbrc --group Layout --key ResetOldOptions --type bool true
      '';
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -U fish_greeting ""
      set -U fish_user_paths $fish_user_paths ~/.local/bin
      ${builtins.readFile ./fish/p.fish}
      ${builtins.readFile ./fish/p-mk.fish}
      ${builtins.readFile ./fish/p-gh.fish}
      direnv hook fish | source
    '';
    shellAliases = {
      e  = "emacsclient";
      ls = "ls --human-readable --almost-all --color=auto";
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    earlySetup = true;
    keyMap = "us";
    font = pkgs.lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  };

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      google-fonts
    ];
  };

}
