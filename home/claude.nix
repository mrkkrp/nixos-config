{ pkgs, ... }:

let
  # Holds a PowerDevil inhibition for as long as the session runs, so the
  # laptop does not suspend while Claude is working.
  inhibited-claude = pkgs.writeShellScript "claude" ''
    exec 3<&0
    exec ${pkgs.kdePackages.kde-cli-tools}/bin/kde-inhibit --power \
      ${pkgs.runtimeShell} -c 'exec 0<&3 3<&-; exec "$0" "$@"' \
      ${pkgs.claude-code}/bin/claude "$@"
  '';

  claude-code = pkgs.symlinkJoin {
    name = "claude-code-${pkgs.claude-code.version}";
    paths = [ pkgs.claude-code ];
    postBuild = ''
      ln -sf ${inhibited-claude} $out/bin/claude
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
