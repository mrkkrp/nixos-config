{ pkgs, osConfig, ... }:
let
  primaryScreen = 0;
  externalScreen = 1;
  emacsTitle = "660c03ad-0f61-438c-9342-957f73cd9b05";
  weztermTitle = "92b2708d-7a7a-41cf-ad6b-69503c4f95bd";
  chromeClass = "^[Gg]oogle-chrome$";
  darktableClass = "^([Oo]rg[.])?[Dd]arktable([.][Dd]arktable)?$";
  emacsClass = "^[Ee]macs$";
  pwsafeClass = "^([Pp]wsafe|PasswordSafe)$";
  weztermClass = "^org[.]wezfurlong[.]wezterm$";
  windowClass = value: {
    inherit value;
    type = "regex";
    match-whole = false;
  };
  # KWin never applies the "screen" window rule to Wayland windows, so a KWin
  # script has to do the placement instead; see the script for details.
  kwinScript = "screen-placement";
  screenPlacement = [
    {
      windowClass = chromeClass;
      screen = externalScreen;
    }
    {
      windowClass = darktableClass;
      screen = externalScreen;
    }
    {
      windowClass = emacsClass;
      screen = externalScreen;
    }
    {
      windowClass = pwsafeClass;
      screen = externalScreen;
    }
    {
      windowClass = weztermClass;
      screen = primaryScreen;
    }
  ];
in
{
  xdg.dataFile = {
    "kwin/scripts/${kwinScript}/metadata.json".text = builtins.toJSON {
      KPackageStructure = "KWin/Script";
      KPlugin = {
        Id = kwinScript;
        Name = "Screen placement";
        Description = "Starts windows on the screen they belong to";
        License = "GPL";
        EnabledByDefault = true;
      };
      "X-Plasma-API" = "javascript";
    };
    "kwin/scripts/${kwinScript}/contents/code/main.js".source =
      pkgs.replaceVars ./dotfiles/kwin-screen-placement.js {
        placement = builtins.toJSON screenPlacement;
      };
  };

  programs.plasma = {
    enable = true;

    input.keyboard = {
      options = [
        "terminate:ctrl_alt_bksp"
        "compose:sclk"
      ];
      repeatDelay = 600;
      repeatRate = 50;
    };

    configFile."kaccessrc".Keyboard = {
      StickyKeys = true;
      StickyKeysLatch = false;
    };

    configFile."kcminputrc".Mouse = {
      XLbInptPointerAcceleration = 1.0;
      XLbInptAccelProfileFlat = false;
    };

    configFile."kwinrc".Plugins."${kwinScript}Enabled" = true;

    kwin.nightLight = {
      enable = true;
      mode = "location";
      location = {
        latitude = toString osConfig.location.latitude;
        longitude = toString osConfig.location.longitude;
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };

    hotkeys.commands = {
      dolphin = {
        key = "Alt+1";
        command = "dolphin";
      };
      google-chrome = {
        key = "Alt+2";
        command = "raise-or-run google-chrome google-chrome-stable";
      };
      emacs = {
        key = "Alt+3";
        command = "raise-or-run ${emacsTitle} emacs";
      };
      wezterm = {
        key = "Alt+4";
        command = "raise-or-run ${weztermTitle} wezterm start";
      };
      lock-screen = {
        key = "Alt+6";
        command = "loginctl lock-session";
      };
    };

    krunner.position = "top";

    window-rules = [
      {
        # This used to also match the "browser" window role, which does not
        # survive the move to Wayland: window roles are an X11 property with
        # no Wayland counterpart.  Restricting the rule to normal windows is
        # enough to keep it off Chrome's dialogs.
        description = "Window settings for google-chrome";
        match.window-class = windowClass chromeClass;
        match.window-types = [ "normal" ];
        apply.noborder = {
          value = true;
          apply = "force";
        };
      }
      {
        description = "darktable is always maximized and borderless";
        match.window-class = windowClass darktableClass;
        # Excludes the transient "Welcome to darktable!" window, which is a
        # normal window sharing darktable's window class.
        match.title = {
          value = "^darktable";
          type = "regex";
        };
        match.window-types = [ "normal" ];
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
          maximizehoriz = {
            value = true;
            apply = "force";
          };
          maximizevert = {
            value = true;
            apply = "force";
          };
        };
      }
      {
        # Forcing the state here means it arrives in the very first
        # xdg_surface.configure, so wezterm builds its terminal grid and glyph
        # atlas once.  Asking for fullscreen from wezterm.lua instead made the
        # window map at the wrong size first and rebuild both.
        description = "wezterm is always fullscreen";
        match.window-class = windowClass weztermClass;
        match.window-types = [ "normal" ];
        apply.fullscreen = {
          value = true;
          apply = "force";
        };
      }
    ];
  };
}
