local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.keys = {
  {
    key = 'LeftArrow',
    mods = 'SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'UpArrow',
    mods = 'SHIFT',
    action = wezterm.action.ScrollByLine(-1),
  },
  {
    key = 'DownArrow',
    mods = 'SHIFT',
    action = wezterm.action.ScrollByLine(1),
  },
  {
    key = 'F7',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'F8',
    action = wezterm.action.ShowTabNavigator,
  },
}

config.color_scheme = 'Zenburn'
config.font = wezterm.font('DejaVu Sans Mono')
config.font_size = @fontSize@
config.front_end = 'WebGpu'
config.audible_bell = 'Disabled'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
-- Fullscreen is forced by a KWin window rule rather than requested here.  A
-- Wayland client only learns its size from the first xdg_surface.configure,
-- so calling toggle_fullscreen() after the window exists costs an extra round
-- trip and makes the terminal grid and the glyph atlas be built twice.  The
-- old position argument is gone for a related reason: Wayland clients cannot
-- place themselves, so it was silently ignored; the screen-placement KWin
-- script does that now.
wezterm.on('format-window-title', function(cmd)
  return "92b2708d-7a7a-41cf-ad6b-69503c4f95bd"
end)
return config
