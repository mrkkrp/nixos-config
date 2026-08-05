{ ... }:
{
  # force = true on all of these: every target here is currently a symlink
  # left by the old imports/symlinks setup, and home-manager's
  # backupFileExtension only backs up plain files, not symlinks - without
  # force, activation either errors ("would be clobbered") or, worse,
  # silently leaves the old symlink in place when content happens to match,
  # which then rots once nix.gc.automatic reaps the old, now-unreferenced
  # store paths it points to.
  xdg.configFile = {
    "kglobalshortcutsrc" = { source = ../.config/kglobalshortcutsrc; force = true; };
    "khotkeysrc" = { source = ../.config/khotkeysrc; force = true; };
    "kwinrulesrc" = { source = ../.config/kwinrulesrc; force = true; };
    "nushell/config.nu" = { source = ../.config/nushell/config.nu; force = true; };
    "nushell/env.nu" = { source = ../.config/nushell/env.nu; force = true; };
  };
  home.file = {
    ".wezterm.lua" = { source = ../.config/wezterm.lua; force = true; };
    ".emacs.d/init.el" = { source = ../emacs/init.el; force = true; };
    ".nixpkgs/config.nix" = { source = ../nixconfig/config.nix; force = true; };
  };
}
