# Highest disk usage in a given directory. Useful for finding what takes up
# most of disk space.
function hdu
    set dir "$argv[1]"
    du -ha --max-depth=1 $argv | sort -hr | head
end
