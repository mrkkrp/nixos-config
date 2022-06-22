function nixos-switch
    pushd .
    trap popd HUP INT QUIT ABRT TERM # doesn't seem to work
    p nixos-config && nixos-rebuild --use-remote-sudo switch --flake .#(hostname)
    popd
end
