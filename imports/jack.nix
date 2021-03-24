# Sound with Jack.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jack2
    qjackctl
  ];
  services.jack.jackd.enable = true;
  services.jack.alsa.enable = true;
}
