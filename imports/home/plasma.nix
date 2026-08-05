{ ... }:
{
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

    hotkeys.commands = {
      dolphin = {
        key = "Alt+1";
        command = "dolphin";
      };
      google-chrome = {
        key = "Alt+2";
        command = ''sh -c "wmctrl -a '- Google Chrome' || google-chrome-stable"'';
      };
      emacs = {
        key = "Alt+3";
        command = ''sh -c "wmctrl -a '660c03ad-0f61-438c-9342-957f73cd9b05' || emacs"'';
      };
      wezterm = {
        key = "Alt+4";
        command = ''sh -c "wmctrl -a '92b2708d-7a7a-41cf-ad6b-69503c4f95bd' || wezterm start"'';
      };
      lock-screen = {
        key = "Alt+6";
        command = "loginctl lock-session";
      };
    };

    window-rules = [
      {
        description = "Application settings for Emacs";
        match.window-class = {
          value = "emacs Emacs";
          match-whole = true;
        };
        apply.screen = {
          value = 2;
          apply = "initially";
        };
      }
      {
        description = "Window settings for google-chrome";
        match.window-class = {
          value = "google-chrome";
          match-whole = false;
        };
        match.window-role = {
          value = "browser";
        };
        match.window-types = [ "normal" ];
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
          position = {
            value = "3840,0";
            apply = "initially";
          };
          screen = {
            value = 2;
            apply = "initially";
          };
        };
      }
    ];
  };
}
