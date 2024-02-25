local wezterm = require 'wezterm'
local mux = wezterm.mux
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
config.font_size = 46.0
config.audible_bell = 'Disabled'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
wezterm.on('gui-startup', function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end
  local tab, pane, window = mux.spawn_window {
      args = args,
      position = { x = 0, y = 0, origin = "MainScreen" },
  }
  window:gui_window():toggle_fullscreen()
end)
return config
