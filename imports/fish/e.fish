function e
    emacsclient --no-wait "$argv[1]"
    wmctrl -a "emacs@"
end
