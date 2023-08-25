# Nushell Environment Config File

def create_left_prompt [] {
    let user_and_host = if (is-admin) {
        $"(ansi red_bold)($env.USER)@(hostname) "
    } else {
        $"(ansi green_bold)($env.USER)@(ansi reset)(hostname) "
    }

    let home = $env.HOME
    let i = ($home | str length)
    let dir = ([
        ($env.PWD | str substring 0..$i | str replace -s $home "~"),
        ($env.PWD | str substring $i..)
    ] | str join)
    let dir_segments = ($dir | path split)
    let segments_total = ($dir_segments | length)
    let dir_shortened = ($dir_segments
        | enumerate
        | each {|e| if $e.index == ($segments_total - 1) {
            $e.item
        } else {
            $e.item | str substring 0..1
        }}
        | path join)
    let path = $"(ansi green_bold)($dir_shortened)"

    let git_branch_raw = (do { git branch } | complete)
    let git_branch = if $git_branch_raw.exit_code != 0 {
        ""
    } else {
        let branch_name = ($git_branch_raw.stdout
            | lines
            | filter { |x| $x | str starts-with '* ' }
            | get 0
            | str substring 2..)
        $" (ansi reset)\(($branch_name)\)"
    }

    let exit_code = if $env.LAST_EXIT_CODE != 0 {
        $" (ansi red_bold)[($env.LAST_EXIT_CODE)]"
    } else {
        ""
    }

    $user_and_host ++ $path ++ $git_branch ++ $exit_code
}

def create_right_prompt [] {
    null
}

$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { "> " }
$env.PROMPT_INDICATOR_VI_INSERT = { ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { "> " }
$env.PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]
