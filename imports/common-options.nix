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

  nix.autoOptimiseStore = true;
  nixpkgs = {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ./overlay.nix)
    ];
  };

  services.chrony.enable = true;
  services.logrotate = {
    enable = true;
    paths = {
      journal = {
        path = "/var/log/journal";
        user = "root";
        group = "systemd-journal";
        frequency = "daily";
        keep = 10;
      };
      nginx = {
        path = "/var/log/nginx";
        user = "mark";
        group = "nginx";
        frequency = "daily";
        keep = 10;
      };
    };
  };
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
      less
      libtool
      man
      man-pages
      nano
      networkmanager
      nginxMainline
      ntfs3g
      patch
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
      "jackaudio"
      "networkmanager"
      "video"
      "wheel"
    ];
    hashedPassword = "$6$rBDWl6/g.dgUp$l6fYq.V1jzQRzsY9o6hSqsB77XAWVjSTLmcrzbjW7zl9DvNeO2LfjOHEOzH7j9Mr1WFofl6FO3CkyITN/UzRp0";
    packages = with pkgs; [
      (import ./emacs pkgs)
      (import ./project-jumper pkgs)
      (wine.override { wineBuild = "wineWow"; })
      alacritty
      alsaLib
      alsaOss
      alsaPlugins
      alsaTools
      alsaUtils
      cabal-install
      darktable
      dbeaver
      direnv
      docker
      docker-compose
      fd
      fish
      flac
      ghc
      gimp
      git
      git-lfs
      google-chrome
      google-cloud-sdk
      haskellPackages.ghcid
      haskellPackages.haskell-language-server
      haskellPackages.hasktags
      haskellPackages.hlint
      # haskellPackages.mmark-cli
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.fr-moderne
      hunspellDicts.ru-ru
      inkscape
      inotify-tools
      insomnia
      niv
      ocaml
      ocamlPackages.ocaml-lsp
      okular
      openconnect
      openssl
      openvpn
      postgresql
      pwsafe
      python3Full
      qbittorrent
      qiv
      ripgrep
      rustup
      shellcheck
      shutter
      stack
      tdesktop
      tmate
      tmux
      virtualbox
      vlc
      wmctrl
      zoom-us
    ];
    shell = "${pkgs.fish}/bin/fish";

    symlinks = {
      ".alacritty.yml" = ./.config/.alacritty.yml;
      ".config/kglobalshortcutsrc" = ./.config/kglobalshortcutsrc;
      ".config/khotkeysrc" = ./.config/khotkeysrc;
      ".config/kwinrulesrc" = ./.config/kwinrulesrc;
      ".emacs.d/init.el" = ./emacs/init.el;
      ".gitconfig" = pkgs.gitconfig;
      ".nixpkgs/config.nix" = pkgs.nixconfig;
      ".stack/config.yaml" = pkgs.stackconfig;
      ".tmux.conf" = ./.config/.tmux.conf;
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
      ${builtins.readFile ./fish/e.fish}
      ${builtins.readFile ./fish/p.fish}
      ${builtins.readFile ./fish/p-mk.fish}
      ${builtins.readFile ./fish/p-gh.fish}
      direnv hook fish | source
    '';
    shellAliases = {
      cal = "cal -m3";
      ls = "ls --human-readable --almost-all --color=auto";
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    earlySetup = true;
    keyMap = "us";
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      google-fonts
    ];
  };

}
