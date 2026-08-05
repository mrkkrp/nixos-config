{ ... }:
{
  xdg.configFile = {
    "kglobalshortcutsrc".source = ../.config/kglobalshortcutsrc;
    "khotkeysrc".source = ../.config/khotkeysrc;
    "kwinrulesrc".source = ../.config/kwinrulesrc;
    "nushell/config.nu".source = ../.config/nushell/config.nu;
    "nushell/env.nu".source = ../.config/nushell/env.nu;
  };
  home.file = {
    ".wezterm.lua".source = ../.config/wezterm.lua;
    ".emacs.d/init.el".source = ../emacs/init.el;
    ".nixpkgs/config.nix".source = ../nixconfig/config.nix;
  };
}
