{ pkgs, ... }:

let
  # Holds a PowerDevil inhibition for as long as the session runs, so the
  # laptop does not suspend while Claude is working.
  claude-code = pkgs.symlinkJoin {
    name = "claude-code-${pkgs.claude-code.version}";
    paths = [ pkgs.claude-code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mv $out/bin/claude $out/bin/.claude-uninhibited
      makeWrapper ${pkgs.kdePackages.kde-cli-tools}/bin/kde-inhibit $out/bin/claude \
        --add-flags --power \
        --add-flags $out/bin/.claude-uninhibited
    '';
    inherit (pkgs.claude-code) meta;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = claude-code;

    settings = {
      model = "opus[1m]";
      effortLevel = "high";
      theme = "dark";
      permissions.defaultMode = "auto";
      attribution.commit = "";
    };
    context = ./dotfiles/CLAUDE.md;
  };
}
