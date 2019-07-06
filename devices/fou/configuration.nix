{ config, pkgs, ... }:

let
  nixPkgsRepo = "/home/mark/nixpkgs";
  nixConfigRepo = "/home/mark/nix-workstation";
in rec {

  imports = [
    ./hardware-configuration.nix
    ./../../imports/common-options.nix
    ];

  networking.hostName = "fou";
  time.timeZone = "Europe/Paris";
  system.stateVersion = "17.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.earlyVconsoleSetup = true;

  nix = {
    package = pkgs.nixUnstable;
    binaryCaches = [
      "https://cache.nixos.org"
    ];
    gc.automatic = false;
    nixPath = [
      "nixpkgs=${nixPkgsRepo}"
      "nixos-config=${nixConfigRepo}/devices/${networking.hostName}/configuration.nix"
    ];
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;

    desktopManager = {
      plasma5.enable = true;
      default = "plasma5";
    };

    displayManager = {
      sddm.enable = true;
      sessionCommands = "export PATH=$HOME/.local/bin:$PATH";
    };
  };

  services.nginx.virtualHosts = {
    "localhost" = {
       listen = [
         {
           addr = "localhost";
           port = 5000;
         }
       ];
       locations."/" = {
         root = "/home/mark/projects/programs/haskell/markkarpov.com/_build/";
         index = "posts.html index.htm";
         extraConfig = "error_page 404 = /404.html;";
       };
    };
  };
  services.nginx.user = "mark";
  services.nginx.enable = true;
}
