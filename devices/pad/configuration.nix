{ config, pkgs, ... }:

let
  nixPkgsRepo = "/home/mark/nixpkgs";
  nixConfigRepo = "/home/mark/projects/mrkkrp/nixos-config";
  nixosHardware = import ./../../imports/nixos-hardware.nix;
in rec {

  imports = [
    ./hardware-configuration.nix
    "${nixosHardware}/lenovo/thinkpad/x1"
    ./../../imports/common-options.nix
    ./../../imports/nginx.nix
    ./../../imports/pulseaudio.nix
    # ./../../imports/jack.nix
    ];

  networking.hostName = "pad";
  time.timeZone = "Europe/Paris";

  location = {
    latitude = 48.864716;
    longitude = 2.349014;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixUnstable;
    binaryCaches = [
      "https://cache.nixos.org"
      "https://hydra.iohk.io"
    ];
    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
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
