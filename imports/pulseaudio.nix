# Sound with Pulseaudio.
{ pkgs, ... }:
{
  nixpkgs.config.pulseaudio = true;
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudioFull
  ];
}
