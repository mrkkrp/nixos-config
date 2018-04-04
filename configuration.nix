#
# Mark Karpov's NixOS configuration
#
# https://github.com/mrkkrp/nix-workstation
#

{ config, pkgs, ... }:

{
  ##########################################################
  # General

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # This value determines the NixOS release with which your
  # system is to be compatible, in order to avoid breaking
  # some software such as database servers. You should
  # change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09";

  ##########################################################
  # Boot

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # This is only needed for BIOS systems:
  # boot.loader.grub.device = "/dev/sda";
  boot.earlyVconsoleSetup = true;

  ##########################################################
  # Extra file systems and swap

  fileSystems = {
    "/home/mark/store" = {
      device = "/dev/sdb1";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { device = "/dev/sd2"; }
  ];

  ##########################################################
  # Packages

  nixpkgs = {
    system = "x86_64-linux";
    config = {
      pulseaudio = true;
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    trustedBinaryCaches = [
      "https://cache.nixos.org"
    ];
    binaryCaches = [
      "https://cache.nixos.org"
    ];
    gc.automatic = false;
    maxJobs = pkgs.stdenv.lib.mkForce 6;
  };

  environment.systemPackages = with pkgs; [
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
    bash
    binutils
    bzip2
    cool-retro-term
    coreutils
    cups
    diffutils
    docker
    dosfstools
    e2fsprogs
    eject
    emacs
    file
    findutils
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
    google-chrome-dev
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
    ntfs3g
    ntp
    openssl
    p7zip
    patch
    pavucontrol
    postgresql
    pulseaudioFull
    python3Full
    ruby
    sudo
    texlive.combined.scheme-full
    tor
    unzip
    vim
    wget
    which
    zip
  ];

  ##########################################################
  # Users

  security.sudo.enable = true;
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.bash;

  users.users.mark = {
    isNormalUser = true;
    createHome = true;
    description = "Mark Karpov";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    hashedPassword = "$6$rBDWl6/g.dgUp$l6fYq.V1jzQRzsY9o6hSqsB77XAWVjSTLmcrzbjW7zl9DvNeO2LfjOHEOzH7j9Mr1WFofl6FO3CkyITN/UzRp0";
    packages = with pkgs; [
      clementine
      coq
      flac
      gimp
      inkscape
      kid3
      lame
      pwsafe
      qbittorrent
      qiv
      vlc
    ];

  };

  ##########################################################
  # Bash

  programs.bash = {
    shellAliases = {
      e  = "emacsclient";
      ls = "ls --human-readable --almost-all --color=auto";
    };
    shellInit = "export PATH=~/.local/bin:$PATH";
    enableCompletion = true;
  };

  ##########################################################
  # Networking

  networking = {
    hostName = "nixos";
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    # networkmanager.enable = true;
    wireless = {
      enable = true;
      networks = {
        "new-one" = {
          psk = "noganoga";
        };
      };
    };
  };

  ##########################################################
  # Misc services

  # services.openssh.enable = true;
  services.printing.enable = true;

  ##########################################################
  # Time

  time.timeZone = "Asia/Novosibirsk";
  services.ntp.enable = true;

  ##########################################################
  # Locale

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  ##########################################################
  # Fonts

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      google-fonts
    ];
  };

  ##########################################################
  # Audio

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  ##########################################################
  # X server and XFCE

  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    videoDrivers = ["nvidia"]; # or "ati_unfree"

    desktopManager = {
      xfce.enable = true;
      default = "xfce";
    };

    displayManager.sddm.enable = true;
  };

  services.redshift = {
    enable = true;
    latitude = "52";
    longitude = "85";
    temperature.day = 5500;
    temperature.night = 3700;
  };

}
