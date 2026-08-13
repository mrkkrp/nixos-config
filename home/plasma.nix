{ ... }:
let
  externalScreen = 1;
in
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

    krunner.position = "top";

    window-rules = [
      {
        description = "Application settings for Emacs";
        match.window-class = {
          value = "emacs Emacs";
          match-whole = true;
        };
        apply = {
          screen = {
            value = externalScreen;
            apply = "initially";
          };
          # Emacs refreshes _NET_WM_USER_TIME whenever it merely receives focus,
          # which makes KWin treat windows launched from KRunner as focus
          # stealers and open them behind Emacs. Dropping focus protection to
          # "None" lets those windows activate normally.
          fpplevel = {
            value = 0;
            apply = "force";
          };
        };
      }
      {
        description = "KRunner always starts on the external screen";
        match.window-class = {
          value = "krunner krunner";
          match-whole = true;
        };
        apply.screen = {
          value = externalScreen;
          apply = "force";
        };
      }
      {
        description = "Google Chrome account chooser starts on the external screen";
        match.window-class = {
          value = "Google-chrome";
          match-whole = false;
        };
        match.title = {
          value = "Google Chrome";
          type = "exact";
        };
        match.window-types = [ "normal" ];
        apply.screen = {
          value = externalScreen;
          apply = "force";
        };
      }
      {
        description = "Window settings for google-chrome";
        match.window-class = {
          value = "Google-chrome";
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
          screen = {
            value = externalScreen;
            apply = "initially";
          };
        };
      }
      {
        description = "darktable always starts on the external screen";
        match.window-class = {
          value = "org.darktable.darktable Org.darktable.darktable";
          match-whole = true;
        };
        apply.screen = {
          value = externalScreen;
          apply = "force";
        };
      }
      {
        description = "darktable is always maximized and borderless";
        match.window-class = {
          value = "org.darktable.darktable Org.darktable.darktable";
          match-whole = true;
        };
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
        description = "pwsafe always starts on the external screen";
        match.window-class = {
          value = "pwsafe PasswordSafe";
          match-whole = true;
        };
        apply.screen = {
          value = externalScreen;
          apply = "force";
        };
      }
    ];
  };
}
