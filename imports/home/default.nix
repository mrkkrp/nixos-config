{ ... }:
{
  home.stateVersion = "26.05";

  home.username = "mark";
  home.homeDirectory = "/home/mark";

  imports = [
    ./git.nix
    ./files.nix
  ];
}
