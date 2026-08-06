{ pkgs, osConfig, ... }:

let
  # The right WezTerm font size depends on the resolution of the primary
  # screen, hence it is per-device.
  weztermFontSize = {
    frame = "32.0";
    pad = "46.0";
  }.${osConfig.networking.hostName};
in
{
  xdg.configFile = {
    "nushell/config.nu".source = ./dotfiles/nushell/config.nu;
    "nushell/env.nu".source = ./dotfiles/nushell/env.nu;
  };
  home.file = {
    ".wezterm.lua".source = pkgs.replaceVars ./dotfiles/wezterm.lua {
      fontSize = weztermFontSize;
    };
    ".emacs.d/init.el".source = ../pkgs/emacs/init.el;
  };
}
