{ ... }:
{
  programs.claude-code = {
    enable = true;

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
