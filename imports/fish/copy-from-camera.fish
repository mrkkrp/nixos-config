function copy-from-camera
    set source_dir "/run/media/$USER/EOS_DIGITAL/DCIM/100EOS_R"
    set target_dir "$HOME/projects/mrkkrp/photos"

    if not test -d "$source_dir"
        echo "$source_dir does not exist, mount the device first."
        return 1
    end

    if not test -d "$target_dir"
        echo "$target_dir must exist!"
        return 1
    end

    for x in (find "$source_dir" -name '*.CR3')
        set modification_date (stat -c '%y' "$x" | awk '{print $1;}')
        set target_sub_dir "$target_dir/$modification_date"
        set basename (basename "$x")
        mkdir -p "$target_sub_dir"
        cp -v "$x" "$target_sub_dir/$basename"
    end
end
