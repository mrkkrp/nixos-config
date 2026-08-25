// KWin ignores the "screen" window rule for Wayland windows:
// XdgToplevelWindow::initialize() applies every other rule but never calls
// rules()->checkOutput(), so a window always ends up wherever KWin would have
// put it anyway, which is workspace()->activeOutput().  X11 windows go through
// X11Window::manage(), which does honour the rule, which is why this only
// started to matter after the move to Wayland.  Place the windows we care
// about ourselves until that is fixed upstream.

const placement = @placement@;

const rules = placement.map(rule => ({
  windowClass: new RegExp(rule.windowClass),
  screen: rule.screen,
}));

workspace.windowAdded.connect(window => {
  if (!window.normalWindow) {
    return;
  }
  const rule = rules.find(rule => rule.windowClass.test(window.resourceClass));
  if (rule === undefined) {
    return;
  }
  // The screen may be missing, e.g. when the external monitor is unplugged.
  const output = workspace.screens[rule.screen];
  if (output !== undefined && output !== window.output) {
    workspace.sendClientToScreen(window, output);
  }
});
