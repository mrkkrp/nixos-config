# Nushell Config File

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: { if $in { 'light_cyan' } else { 'light_gray' } }
    int: white
    filesize: {|e|
      if $e == 0b {
        'white'
      } else if $e < 1mb {
        'cyan'
      } else { 'blue' }
    }
    duration: white
    date: { (date now) - $in |
      if $in < 1hr {
        'red3b'
      } else if $in < 6hr {
        'orange3'
      } else if $in < 1day {
        'yellow3b'
      } else if $in < 3day {
        'chartreuse2b'
      } else if $in < 1wk {
        'green3b'
      } else if $in < 6wk {
        'darkturquoise'
      } else if $in < 52wk {
        'deepskyblue3b'
      } else { 'dark_gray' }
    }
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
}

$env.config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  table: {
    mode: compact # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }

  explore: {
    help_banner: true
    exit_esc: true

    command_bar_text: '#C4C9C6'
    # command_bar: {fg: '#C4C9C6' bg: '#223311' }

    status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6' }
    # status_bar_text: {fg: '#C4C9C6' bg: '#223311' }

    highlight: {bg: 'yellow' fg: 'black' }

    status: {
      # warn: {bg: 'yellow', fg: 'blue'}
      # error: {bg: 'yellow', fg: 'blue'}
      # info: {bg: 'yellow', fg: 'blue'}
    }

    try: {
      # border_color: 'red'
      # highlighted_color: 'blue'

      # reactive: false
    }

    table: {
      split_line: '#404040'

      cursor: true

      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true

      show_head: true
      show_index: true

      # selected_cell: {fg: 'white', bg: '#777777'}
      # selected_row: {fg: 'yellow', bg: '#C1C2A3'}
      # selected_column: blue

      # padding_column_right: 2
      # padding_column_left: 2

      # padding_index_left: 2
      # padding_index_right: 1
    }

    config: {
      cursor_color: {bg: 'yellow' fg: 'black' }

      # border_color: white
      # list_color: green
    }
  }

  history: {
    max_size: 10000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  cursor_shape: {
    emacs: block # block, underscore, line (line is the default)
    vi_insert: block # block, underscore, line (block is the default)
    vi_normal: underscore # block, underscore, line  (underscore is the default)
  }
  color_config: $dark_theme   # if you want a light theme, replace `$dark_theme` with `$light_theme`
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2 # the precision for displaying floats in tables
  # buffer_editor: "emacs" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  edit_mode: emacs # emacs, vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  # true or false to enable or disable the welcome banner at startup
  show_banner: false
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.

  hooks: {
    pre_prompt: [{
      code: "
        direnv export json | from json | default {} | load-env
      "
    }]
    pre_execution: [{
      null  # replace with source code to run before the repl input is run
    }]
    env_change: {
    }
    display_output: {
      if (term size).columns >= 100 { table -e } else { table }
    }
  }
  menus: [
      # Configuration for default nushell menus
      # Note the lack of source parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
  ]
}

# Aliases

alias cal = ^cal -m
alias ls = ls --all

# Custom commands

# Open a file or directory in Emacs and switch to the Emacs window.
def e [
    path: path # path to open
] {
    emacsclient --no-wait $path
    wmctrl -a "660c03ad-0f61-438c-9342-957f73cd9b05"
}

# Go to a project directory.
def --env p [
    project: string # name of the project (or its part)
] {
    cd (project-jumper $project)
}

# Ensure that a directory corresponding to org/repo exists and switch to it.
def --env "p mk" [
    org: string # GitHub organization
    repo: string # GitHub repo
] {
    let target = $"($env.HOME)/projects/($org)/($repo)"
    mkdir $target
    cd $target
}

# Setup a project directory by clonning from GitHub.
def --env "p gh" [
    org: string # GitHub organization
    repo: string # GitHub repo
] {
    p mk $org $repo
    git clone $"git@github.com:($org)/($repo).git" .
}

# Rebuild the system from the current configuration and switch to it.
def "nixos switch" [] {
    cd $"($env.HOME)/projects/mrkkrp/nixos-config"
    nixos-rebuild --use-remote-sudo switch --flake $'.#(hostname)'
    nixos diff
}

# Show the diff between the current system and the one N generations earlier.
def "nixos diff" [
    n: int = 1 # how many generations back to go
] {
    let generations = (ls /nix/var/nix/profiles/system-*-link
        | get name
        | sort -nr)
    if $n < ($generations | length) {
       nvd diff ($generations | get $n) /nix/var/nix/profiles/system
    } else {
        error make {
            msg: $"There are ($generations | length) generations in total"
        }
    }
}

# Make the current git repository default to the email from the global config.
def "git personal" [] {
    git config --unset user.email | complete | ignore
}

# Make the current git repository use my work email.
def "git tweag" [] {
    git config --local user.email "mark.karpov@tweag.io" | complete | ignore
}

# Print who git thinks I am.
def "git whoami" [] {
    git config --get user.name
    git config --get user.email
}

# Delete local branches that track no longer existing remote branches.
def "git purge" [
    remote: string = "origin" # remote to align to
] {
    git fetch $remote
    git remote prune $remote
    git branch -vv
        | grep ': gone]'
        |  grep -v '*'
        | awk '{ print $1; }'
        | xargs -r git branch -D
}

# Output biggest entries in a given directory.
def hdu [
    dir: path = '.' # directory to analyze
] {
    let raw_result = (du --all $dir)
    let dir_entries = if ($raw_result | get directories.0 | is-empty) {
        []
    } else {
        $raw_result | get directories.0 | select path apparent physical
    }
    let file_entries = if ($raw_result | get files.0 | is-empty) {
        []
    } else {
        $raw_result | get files.0 | select path apparent physical
    }
    let entries = ($dir_entries
        | append $file_entries
        | sort-by --reverse apparent physical
        | first 10
        | insert type {|e| $e.path | path type })
    $entries
}

# Copy raw images from my Canon EOS R camera.
def copy-from-camera [] {
    let source_dir = $"/run/media/($env.USER)/EOS_DIGITAL/DCIM/100EOS_R"
    let target_dir = $"($env.HOME)/projects/mrkkrp/photos"
    if not ($source_dir | path exists) {
        error make {
            msg: $"($source_dir) must exist!"
        }
    }
    if not ($target_dir | path exists) {
        error make {
            msg: $"($target_dir) must exist!"
        }
    }
    ls ($source_dir ++ "/*.CR3") | each { |e|
        let modification_date = ($e.modified | format date "%Y-%m-%d")
        let target_subdir = $"($target_dir)/($modification_date)"
        let basename = (basename $e.name)
        mkdir $target_subdir
        cp -v $e.name $"($target_subdir)/($basename)"
    } | ignore
}

# Format all Haskell files in the current git repository.
def "ormolu all" [] {
    ormolu -i ...(git ls-files '*.hs' '*.hs-boot' | lines)
}
