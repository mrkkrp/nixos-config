# http://localhost:631/
{ pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [pkgs.hplip];
}
