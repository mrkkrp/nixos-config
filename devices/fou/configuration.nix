{ config, pkgs, ... }:

let
  nixPkgsRepo = "/home/mark/nixpkgs";
  nixConfigRepo = "/home/mark/projects/mrkkrp/nixos-config";
in rec {

  imports = [
    ./hardware-configuration.nix
    ./../../imports/common-options.nix
    ./../../imports/nginx.nix
    ];

  networking.hostName = "fou";
  time.timeZone = "Europe/Paris";

  location = {
    latitude = 48.864716;
    longitude = 2.349014;
  };

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
}
