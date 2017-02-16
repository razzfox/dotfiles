#!/bin/bash

# Path to XDG shortcut (*.desktop) directories.
# xdg_paths=(
#     "$HOME/.local/share/applications"
#     /usr/local/share/applications
#     /usr/share/applications
# )

# Path to Dmenu Launcher cache will be stored.
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
cache="$cachedir/dmenu_launch.cache"

# Path to history file.
hist="$cachedir/dmenu_launch.history"
cmdhist="$cachedir/dmenu_launch"

# Dmenu command.
opt_term=false
if test $1 = "-T" ; then
  opt_term=true
  shift
fi
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


# Functions
sighandler () {
  rm "$hist"
  exit
}

trap sighandler SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM


# list_xdg_shortcuts () {
#     local path
#     echo > "${cache}-shortcuts.tmp"
#     for path in "${xdg_paths[@]}"; do
#         [[ ! -d "$path" ]] && continue
#         while read -r file; do
#             basename=$(basename "$file")
#             if ! grep -Fix "$basename" "${cache}-shortcuts.tmp"; then
#                 echo "$file"
#                 echo "${file##*/}" >> "${cache}-shortcuts.tmp"
#             fi
#         done < <(find -L "$path" -type f -name '*.desktop')
#     done
#     rm "${cache}-shortcuts.tmp"
# }
#
#
# app_list () {
#     # Cache names and executable paths of XDG shortcuts.
#     while read -r file; do
#         # Grab the friendly names and paths of the executable.
#         awk -F'=' '
#             /^ *Name=/ { name=$2 }
#             /^ *Exec=/ { exec=$2 }
#             {
#                 if (name != "" && exec != "") {
#                     print name "\t" exec
#                     name=""
#                     exec=""
#                 }
#             }
#         ' "$file" 2>/dev/null
#     done > "$cache" < <(list_xdg_shortcuts)
#     # Start printing out the menu items, starting with XDG shortcut names...
#     sed 's/\t.*$//' "$cache" | sort -fu
# }

bin_list () {
    # ...then, the binary names...
    if which lsx &>/dev/null; then
        (IFS=':'; lsx $PATH | sort -u)
    else
        lsx | sort -u
    fi
}

update_history () {
    test -n "$2" || return

    echo "$2" > "$1.new"
    grep -Fvx "$2" "$1" >> "$1.new"
    # Unlimited history
    # (echo "$1"; head -9 "$hist" | grep -Fvx "$1") > "$hist"
    mv "$1"{.new,}
}

opt_menu () {
    echo "Start Terminal
Clear History"
}

build_menu () {
    mkdir -p "${hist%/*}"
    touch "$hist"

    # each list must be separated by a newline
#     menu_items="$(app_list)
# $(bin_list)
# $(opt_menu)"
    menu_items="$(bin_list)
$(opt_menu)"

    # hist_items="$(grep -Fx "$menu_items" "$hist")"
    #
    # # # Keep the history file free of invalids.
    # echo "$hist_items" > "$hist"
    #
    # echo "$hist_items"
    # echo "$menu_items" | grep -Fvx "$hist_items"

    cat "$hist"
    echo "$menu_items" | grep -Fvxf "$hist"
}

program_exists () {
    type -p "$1" &>/dev/null
}

get_arguments () {
    arguments="$( cat "$cmdhist.${1// }" | $dm -p "Arguments for '$1'" )"
    if test -n "$arguments" ; then
        update_history "$cmdhist.${1// }" "$arguments"
    fi
}

launch_selection () {
    if ! program_exists "$selection" ; then
        app=$( grep -F "$selection"$'\t' "$cache" | sed 's/.*\t//;s/ %.//g' )

        # If there's more than one, ask which binary to use.
        test "$( echo "$app" | wc -l )" -ne 1 && app="$( echo "$app" | $dm -p "Which binary?" )"

        # Inverts terminal vs background launch behavior
        if $opt_term ; then
            get_arguments $app
            app="$TERMINAL -e $app $arguments"
        fi

        # echo "$app" | $dm -p "Launching:"
        # file "$app" | grep -q "POSIX shell script" && bash $app
        # exec $app

        # IntelliJ Idea has quotes around the listed filename, which causes it to not be found, since the quotes are never dropped from the executable path
        exec ${app//'"'} 2>$cachedir/dmenu_launch.err
    fi

    # No quotes here so that only the first word is tested for an executable
    if program_exists $selection ; then
        update_history "$cmdhist.${selection%% *}" "${selection#* }"


        # Inverts terminal vs background launch behavior
        #if ! $opt_term ; then
        if $opt_term ; then
            selection="$TERMINAL -e $selection"
        fi

        # echo "$selection" | $dm -p "Exec:"
        exec ${selection} ${arguments}
    fi
}


main () {
    # Ask the user to select a program to launch.
    selection=$( build_menu | $dm )

    # Quit if nothing was selected.
    test -z "$selection" && exit 1

    case "$selection" in
        "Clear History")
            confirm=$(printf '%s\n' '[Yes]' '[No]' |
                $dm -p "Clear History?")
            [[ -z "$confirm" || "$confirm" == '[No]' ]] && continue
            rm "$hist"
            ;;
        "Start Terminal")
            opt_term=true
            selection=$( build_menu | $dm -p "In new $TERMINAL terminal" )
            test -z "$selection" && exit 1
            ;&
        *)
            update_history "$hist" "$selection"
            launch_selection "$selection"
            ;;
    esac
}

main "$@"
