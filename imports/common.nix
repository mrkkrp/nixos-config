# These are the options which are shared between all configurations/devices.
{ config, pkgs, nixpkgs, ormolu, ... }:
{
  system.stateVersion = "19.09";

  imports = [
    ./symlinks/activation-script.nix
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    networkmanager.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc.automatic = false;
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [ "nixpkgs=/etc/channels/nixpkgs" ];
  };

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
    settings = {
      journal = {
        files = [ "/var/log/journal" ];
        frequency = "daily";
        rotate = 10;
      };
      nginx = {
        files = [ "/var/log/nginx/*.log" ];
        frequency = "daily";
        rotate = 10;
      };
    };
  };
  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };
  virtualisation.docker.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment = {
    shells = with pkgs; [
      nushell
    ];
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
      nushell
      patch
      sudo
      unzip
      vim
      wget
      which
      zip
      zlib
    ];
    etc."channels/nixpkgs".source = nixpkgs.outPath;
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
      alsa-lib
      alsa-oss
      alsa-plugins
      alsa-tools
      alsa-utils
      cabal-install
      codespell
      darktable
      direnv
      dmidecode
      docker
      docker-compose
      fd
      fx
      ghc
      gimp
      git
      git-lfs
      google-chrome
      haskellPackages.haskell-language-server
      haskellPackages.hlint
      haskellPackages.implicit-hie
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.fr-moderne
      hunspellDicts.ru-ru
      inotify-tools
      kdePackages.okular
      musescore
      nixpkgs-fmt
      nvd
      openconnect
      openssl
      ormolu.packages.x86_64-linux.default
      proselint
      pwsafe
      python3Full
      qbittorrent
      ripgrep
      shellcheck
      shutter
      telegram-desktop
      tmate
      vlc
      wezterm
      wmctrl
      zoom-us
    ];
    shell = pkgs.nushell;

    symlinks = {
      ".config/kglobalshortcutsrc" = ./.config/kglobalshortcutsrc;
      ".config/khotkeysrc" = ./.config/khotkeysrc;
      ".config/kwinrulesrc" = ./.config/kwinrulesrc;
      ".config/nushell/config.nu" = ./.config/nushell/config.nu;
      ".config/nushell/env.nu" = ./.config/nushell/env.nu;
      ".emacs.d/init.el" = ./emacs/init.el;
      ".gitconfig" = pkgs.gitconfig;
      ".nixpkgs/config.nix" = pkgs.nixconfig;
      ".wezterm.lua" = ./.config/wezterm.lua;
    };
  };

  services = {
    xserver = {
      enable = true;
      dpi = null;
      xkb.layout = "us";
      displayManager = {
        sessionCommands = ''
          export PATH=$HOME/.local/bin:$PATH
          export PATH=$HOME/.cabal/bin:$PATH
          kwriteconfig5 --file $HOME/.config/kaccessrc --group Keyboard --key StickyKeys --type bool true
          kwriteconfig5 --file $HOME/.config/kcminputrc --group Keyboard --key RepeatDelay 600
          kwriteconfig5 --file $HOME/.config/kcminputrc --group Keyboard --key RepeatRate 50
          kwriteconfig5 --file $HOME/.config/kxkbrc --group Layout --key Options "terminate:ctrl_alt_bksp,compose:sclk"
          kwriteconfig5 --file $HOME/.config/kxkbrc --group Layout --key ResetOldOptions --type bool true
        '';
      };
    };
    libinput.enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmax11";
    };
    desktopManager.plasma6.enable = true;
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
    packages = with pkgs; [
      corefonts
      google-fonts
    ];
  };

}
