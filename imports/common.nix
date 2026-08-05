# These are the options which are shared between all configurations/devices.
{ config, pkgs, nixpkgs, ormolu, home-manager, plasma-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Lets home-manager take over dotfiles that are currently plain
    # symlinks created by the old imports/symlinks mechanism, by renaming
    # them out of the way instead of refusing to activate.
    backupFileExtension = "backup";
    sharedModules = [
      plasma-manager.homeModules.plasma-manager
    ];
    users.mark = import ./home;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    networkmanager.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "mark" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [ "nixpkgs=/etc/channels/nixpkgs" ];
    package = pkgs.nixVersions.latest;
  };

  nixpkgs = {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
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
    settings = {
      default-cache-ttl = 28800;
      default-cache-ttl-ssh = 28800;
      max-cache-ttl = 28800;
      max-cache-ttl-ssh = 28800;
    };
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

  security = {
    sudo.enable = true;
    pam.services = {
      login.enableKwallet = true;
      sddm.enableKwallet = true;
    };
  };

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
      "libvirtd"
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
      claude-code
      codespell
      darktable
      direnv
      dmidecode
      docker
      docker-compose
      fd
      fx
      gh
      ghc
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
      nixpkgs-fmt
      nvd
      openconnect
      openssl
      ormolu.packages.x86_64-linux.default
      proselint
      pwsafe
      python3
      qbittorrent
      ripgrep
      shellcheck
      shutter
      telegram-desktop
      tmate
      vcmi
      vlc
      wezterm
      wmctrl
      zoom-us
    ];
    shell = pkgs.nushell;
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
