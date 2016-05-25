#!/bin/bash

# Path to XDG shortcut (*.desktop) directories.
xdg_paths=(
    "$HOME/.local/share/applications"
    /usr/local/share/applications
    /usr/share/applications
)

# Path to Dmenu Launcher cache will be stored.
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
cache="$cachedir/dmenu_launch.cache"

# Path to history file.
hist="$cachedir/dmenu_launch.history"

# Path to lock file.
lock="$cachedir/dmenu_launch.lock"

# Dmenu command.
dm="dmenu -i $DMENU_OPTIONS $@"

# Choose proper LSX binary.
if type -p lsx-suckless >/dev/null; then
    # New LSX
    lsx () { lsx-suckless "$@"; }
elif type -p lsx >/dev/null; then
    # Old LSX
    true
else
    # Use compgen cleverness.
    lsx () { compgen -c -X '_*' | grep -Fv "$(compgen -bk)"; }
fi


list_xdg_shortcuts () {
    local path
    echo > "${cache}-shortcuts.tmp"
    for path in "${xdg_paths[@]}"; do
        [[ ! -d "$path" ]] && continue
        while read -r file; do
            basename=$(basename "$file")
            if ! grep -Fix "$basename" "${cache}-shortcuts.tmp"; then
                echo "$file"
                echo "${file##*/}" >> "${cache}-shortcuts.tmp"
            fi
        done < <(find -L "$path" -type f -name '*.desktop')
    done
    rm "${cache}-shortcuts.tmp"
}


app_list () {
    # Cache names and executable paths of XDG shortcuts.
    while read -r file; do
        # Grab the friendly names and paths of the executable.
        awk -F'=' '
            /^ *Name=/ { name=$2 }
            /^ *Exec=/ { exec=$2 }
            {
                if (name != "" && exec != "") {
                    print name "\t" exec
                    name=""
                    exec=""
                }
            }
        ' "$file" 2>/dev/null
    done > "$cache" < <(list_xdg_shortcuts)
    # Start printing out the menu items, starting with XDG shortcut names...
    sed 's/\t.*$//' "$cache" | sort -fu
  }

bin_list () {
    # ...then, the binary names...
    if which lsx &>/dev/null; then
        (IFS=':'; lsx $PATH | sort -u)
    else
        lsx | sort -u
    fi
}

cache_menu () {
    touch "${cache}-menu.lock"

    # Create cache directory if it doesn't exist.
    mkdir -p "${cache%/*}"
    app_list > "${cache}-menu.new"
    bin_list >> "${cache}-menu.new"

    mv "${cache}-menu"{.new,}
    rm "${cache}-menu.lock"
}

update_history () {
    (echo "$1"; head -9 "$hist" | grep -Fvx "$1") > "$hist.new"
    mv "$hist"{.new,}
}

build_opt_menu () {
    echo "Clear History"
}

build_hist_menu () {
    mkdir -p "${hist%/*}"
    touch "$hist"
    # each list must be separated by a newline
    menu_items="$(app_list)
$(bin_list)
$(build_opt_menu)"
    hist_items="$(grep -Fx "$menu_items" "$hist")"

    # # Keep the history file free of invalids.
    # echo "$hist_items" > "$hist"

    echo "$hist_items"
    echo "$menu_items" | grep -Fvx "$hist_items"
}

program_exists () {
    type -p "$1" &>/dev/null
}


main () {
    cache_menu &

    while [[ -f "${cache}-menu.lock" ]]; do
        # "Waiting for menu caching to finish..."
        sleep 0.25
    done

    # Ask the user to select a program to launch.
    selection=$(build_hist_menu | $dm)

    case "$selection" in
        *"Clear History"*)
            confirm=$(printf '%s\n' '[Yes]' '[No]' |
                $dm -p "Clear History?")
            [[ -z "$confirm" || "$confirm" == '[No]' ]] && continue
            rm -f "$hist"
            touch "$hist"
            ;;
        *)
            # Quit if nothing was selected.
            test -z "$selection" && exit 1

            app="$selection"

            # If the selection doesn't exist, see if it's an XDG shortcut.
            if ! program_exists "$selection"; then
                app=$(grep -F "$app"$'\t' "$cache" | sed 's/.*\t//;s/ %.//g')

                # If there's more than one, ask which binary to use.
                test "$(echo "$app" | wc -l)" != '1' && app=$(echo "$app" | $dm -p "Which binary?")
            fi

            # Check and see if the binary exists, and launch it, if so.
            if program_exists $app; then
                update_history "$selection"
                if app_list | grep "$selection"; then
                  exec $selection
                else
                  exec $TERMINAL -e $app
                fi
                exit
            else
                echo '[OK]' | $dm -p "No binary found at '$app'"
            fi
            ;;
    esac
}

main "$@"
