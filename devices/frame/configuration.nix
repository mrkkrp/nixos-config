{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "frame";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
