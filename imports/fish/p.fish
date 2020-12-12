function p
    set target (project-jumper "$argv[1]")
    if test $status -eq 0
        cd "$target"
    else
        return 1
    end
end
