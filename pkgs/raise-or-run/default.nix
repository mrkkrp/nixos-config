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
      if ! error=$(systemd-run --user --collect --quiet \
                     "''${token[@]}" --unit="$unit" -- "$@" 2>&1); then
        # A name that is already taken is the answer we were looking for and
        # not worth reporting; anything else is a real failure.
        if ! systemctl --user is-active --quiet -- "$unit"; then
          echo "raise-or-run: $error" >&2
          exit 1
        fi
      fi
    fi

    exec kdotool search "$pattern" windowactivate %@
  '';
}
