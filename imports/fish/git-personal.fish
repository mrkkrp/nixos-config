function git-personal
    # Will default to my personal email as per the global config
    git config --unset user.email || true
end
