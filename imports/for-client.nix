# Temporary system packages for the current client project.
{ config, pkgs, ... }:
{
  users.users.mark.packages = with pkgs; [
  ];
}
