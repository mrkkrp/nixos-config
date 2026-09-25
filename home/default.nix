{ config, lib, ... }:
{
  home.stateVersion = "26.05";

  home.username = "mark";
  home.homeDirectory = "/home/mark";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cabal/bin"
  ];

  xdg.configFile."plasma-workspace/env/session-path.sh" = {
    executable = true;
    text = ''
      export PATH="${lib.concatStringsSep ":" config.home.sessionPath}:$PATH"
    '';
  };

  imports = [
    ./claude.nix
    ./git.nix
    ./files.nix
    ./plasma.nix
  ];
}
