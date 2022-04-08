{ config, pkgs, ... }:

rec {

  imports = [
    ./hardware-configuration.nix
    ];

  networking.hostName = "pad";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixUnstable;
    gc.automatic = false;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
}
