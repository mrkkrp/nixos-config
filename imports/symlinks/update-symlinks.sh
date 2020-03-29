#!/usr/bin/env bash

update_symlink() {
    local USER
    local SRC
    local DEST
    local OUTDIR

    USER="$1"
    SRC="$2"
    DEST="$3"
    OUTDIR=$(dirname "$DEST");

    # If parent directory of the link to create does not exist, create it.
    if [ ! -d "$OUTDIR" ]; then
        mkdir -p "$OUTDIR"
        chown "$USER:users" "$OUTDIR"
    fi

    # Check if destination is not a directory.
    if [ ! -L "$DEST" ] && [ -d "$DEST" ]; then
        echo "DEST ($DEST) is a directory?"
        return 1
    fi

    # If destination is already a symlink, return early if it already links
    # to the right path.
    if [ -L "$DEST" ]; then
        local CURSRC
        CURSRC=$(realpath "$DEST")
        if [ "$CURSRC" == "$SRC" ]; then
            return 0
        fi
    fi

    # Otherwise create the symlink and then move it to the distination.
    ln -s "$SRC" "/tmp/temp-symlink"
    mv "/tmp/temp-symlink" "$DEST"
}
