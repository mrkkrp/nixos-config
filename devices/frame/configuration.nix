{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "frame";
  system.stateVersion = "26.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
