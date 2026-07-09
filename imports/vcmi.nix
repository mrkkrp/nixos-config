{ pkgs, vcmi, ... }:
{
  # Bleeding-edge VCMI built from the local checkout at
  # /home/mark/projects/vcmi/vcmi via its own nix flake (see flake input
  # `vcmi` in the top-level flake.nix). Only git-tracked files are built,
  # so commit local changes before rebuilding to have them included.
  environment.systemPackages = [
    vcmi.packages.${pkgs.system}.default
  ];
}
