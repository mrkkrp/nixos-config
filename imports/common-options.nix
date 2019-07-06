# These are the options which are shared between all configurations/devices.
{ config, pkgs, ... }:
{
  imports = [
    ./symlinks/service.nix
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    networkmanager.enable = true;
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

  services.tor.enable = true;
  services.ntp.enable = true;
  services.redshift = {
    enable = true;
    latitude = "52";
    longitude = "85";
    temperature.day = 5500;
    temperature.night = 3700;
  };
  virtualisation.docker.enable = true;
  programs.gnupg.agent.enable = true;

  environment = {
    systemPackages = with pkgs; [
      alsaLib
      alsaOss
      alsaPlugins
      alsaTools
      alsaUtils
      aspell
      aspellDicts.en
      aspellDicts.ru
      autoconf
      automake
      binutils
      bzip2
      cargo
      coreutils
      cups
      diffutils
      docker
      dosfstools
      e2fsprogs
      eject
      file
      findutils
      fish
      gcc
      gdb
      git
      glibc
      gnugrep
      gnumake
      gnupg
      gnused
      gnutar
      gnutls
      google-chrome
      groff
      htop
      inetutils
      less
      libtool
      man
      man-pages
      mupdf
      nano
      networkmanager
      nginxMainline
      nixops
      ntfs3g
      ntp
      openssl
      openvpn
      p7zip
      patch
      pavucontrol
      postgresql
      pulseaudioFull
      python3Full
      ruby
      rustc
      sudo
      texlive.combined.scheme-full
      tor
      unzip
      vim
      virtualbox
      wget
      which
      zip
    ];

    etc = {
      "i3/config".source = pkgs.i3config;
    };

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
      bazel
      cabal-install
      coq
      emacs
      flac
      gimp
      haskellPackages.ghcid
      haskellPackages.hasktags
      haskellPackages.hlint
      inkscape
      inotify-tools
      kid3
      lame
      pwsafe
      qbittorrent
      qiv
      stack
      tdesktop
      vlc
      wmctrl
    ];
    shell = "${pkgs.fish}/bin/fish";

    symlinks = {
      ".gitconfig" = pkgs.gitconfig;
      ".nixpkgs/config.nix" = pkgs.nixconfig;
      ".stack/config.yaml" = pkgs.stackconfig;
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;

    # windowManager = {
    #   default = "i3";
    #   i3 = {
    #     enable = true;
    #     configFile = "/etc/i3/config";
    #   };
    # };

    desktopManager = {
      plasma5.enable = true;
      default = "plasma5";
    };

    displayManager = {
      sddm.enable = true;
      sessionCommands = "export PATH=$HOME/.local/bin:$PATH";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -U fish_greeting ""
      set -U fish_user_paths $fish_user_paths ~/.local/bin
    '';
    shellAliases = {
      e  = "emacsclient";
      ls = "ls --human-readable --almost-all --color=auto";
    };
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
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
