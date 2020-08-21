function p-mk
    switch (count $argv)
        case 2
            set target "$HOME/projects/$argv[1]/$argv[2]"
            mkdir -p "$target"
            cd "$target"
        case '*'
            echo "This command takes 2 arguments:"
            echo "p-mk <org-name> <project-name>"
            return 1
    end
end
