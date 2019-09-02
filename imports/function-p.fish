function p
    switch (count $argv)
        case 1
            # Just project name, try to guess org name
            set ds (find "$HOME/projects" -mindepth 2 -maxdepth 2 -type d -name "$argv[1]*" | sort)
        case 2
            set ds (find "$HOME/projects/$argv[1]" -mindepth 1 -maxdepth 1 -type d -name "$argv[2]*" | sort)
            # Project name and org name are specified
        case '*'
            echo "This command take 1 or 2 arguments:"
            echo "p <project-name>"
            echo "p <org-name> <project-name>"
            return 1
    end
    set total_ds (count $ds)
    switch $total_ds
        case 0
            echo "No matches found."
            return 1
        case 1
            cd "$ds[1]"
        case '*'
            echo "> $ds[1]"
            for d in $ds[2.."$total_ds"]
                echo "  $d"
            end
            cd "$ds[1]"
    end
end
