{ config, pkgs, ... }:

rec {
  imports = [
    ./hardware-configuration.nix
    ];
  networking.hostName = "old";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
