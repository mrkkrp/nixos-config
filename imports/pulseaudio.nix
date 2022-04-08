# Sound with Pulseaudio.
{ pkgs, ... }:
{
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudioFull
  ];
}
