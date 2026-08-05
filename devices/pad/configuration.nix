{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "pad";
  system.stateVersion = "19.09";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
