function git-prune
    if test (count $argv) -le 1
        set remote "origin"
    else
        set remote "$argv[1]"
    end
    git fetch "$remote"
    git remote prune "$remote"
    git branch -vv | grep ': gone]' |  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
end
