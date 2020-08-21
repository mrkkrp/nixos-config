function p-gh
    switch (count $argv)
        case 2
            p-mk "$argv[1]" "$argv[2]"
            git clone "git@github.com:$argv[1]/$argv[2].git" .
        case '*'
            echo "This command takes 2 arguments:"
            echo "p-ph <org-name> <project-name>"
            return 1
    end
end
