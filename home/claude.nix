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

  # Shows the session's directory and branch, so that sessions in different
  # work trees can be told apart.
  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [ pkgs.jq pkgs.git pkgs.coreutils ];
    text = ''
      dir=$(jq -r .workspace.current_dir)
      branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null || true)
      printf '%s' "$(basename "$dir")''${branch:+ ($branch)}"
    '';
  };
in
{
  programs.claude-code = {
    enable = true;
    package = claude-code;

    settings = {
      model = "opus[1m]";
      theme = "dark";
      permissions.defaultMode = "auto";
      attribution.commit = "";
      statusLine = {
        type = "command";
        command = "${statusline}/bin/claude-statusline";
      };
    };
    context = ./dotfiles/CLAUDE.md;
  };
}
