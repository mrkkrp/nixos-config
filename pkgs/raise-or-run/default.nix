pkgs:

# Activate the first window matching a pattern, or start a program when there
# is no such window.
pkgs.writeShellApplication {
  name = "raise-or-run";
  runtimeInputs = [ pkgs.kdotool ];
  text = ''
    if [ "$#" -lt 2 ]; then
      echo "usage: raise-or-run PATTERN PROGRAM [ARG...]" >&2
      exit 2
    fi

    pattern="$1"
    shift

    # kdotool exits with 0 whether or not it found anything, so the output is
    # the only thing we can go by.  PATTERN must not start with a dash, since
    # kdotool would take it for an option.
    mapfile -t windows < <(kdotool search "$pattern")

    if [ "''${#windows[@]}" -gt 0 ]; then
      exec kdotool windowactivate "''${windows[0]}"
    else
      exec "$@"
    fi
  '';
}
