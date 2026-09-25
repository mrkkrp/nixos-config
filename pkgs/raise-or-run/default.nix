pkgs:

# Activate the first window matching a pattern, or start a program when there
# is no such window.
pkgs.writeShellApplication {
  name = "raise-or-run";
  runtimeInputs = [
    pkgs.kdotool
    pkgs.systemd
  ];
  text = ''
    if [ "$#" -lt 2 ]; then
      echo "usage: raise-or-run PATTERN PROGRAM [ARG...]" >&2
      exit 2
    fi

    pattern="$1"
    shift

    if [ -z "$(kdotool search "$pattern")" ]; then
      unit="raise-or-run-$(systemd-escape -- "$(basename -- "$1")").service"
      token=()
      if [ -n "''${XDG_ACTIVATION_TOKEN:-}" ]; then
        token=("--setenv=XDG_ACTIVATION_TOKEN=''${XDG_ACTIVATION_TOKEN}")
      fi
      launch() {
        systemd-run --user --collect --quiet \
          "''${token[@]}" --unit="$unit" -- "$@" 2>&1
      }
      fail() {
        echo "raise-or-run: $1" >&2
        exit 1
      }
      if ! error=$(launch "$@"); then
        # A name that is already taken is the answer we were looking for and
        # not worth reporting; anything else is a real failure.
        case "$(systemctl --user show --property=ActiveState --value -- "$unit")" in
          active | activating) ;;
          deactivating)
            # The window is gone but leftover processes ignoring SIGTERM
            # keep the name taken until the stop timeout expires.
            systemctl --user kill --signal=SIGKILL -- "$unit" || true
            systemctl --user stop -- "$unit" 2>/dev/null || true
            error=$(launch "$@") || fail "$error"
            ;;
          *) fail "$error" ;;
        esac
      fi
    fi

    exec kdotool search "$pattern" windowactivate %@
  '';
}
