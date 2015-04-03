# dmenu 251406c4eb taken Jan 23, 2014 from https://github.com/Wintervenom/Scripts/blob/master/file/launch/dmenu-launch

# Path to XDG shortcut (*.desktop) directories.
xdg_paths=(
    /usr/share/applications
    /usr/local/share/applications
    $HOME/.local/share/applications
)

# Choose proper LSX binary.
if which 'lsx' >/dev/null 2>/dev/null; then
    lsx=lsx
else
    IFS=:
    lsx='stest -flx $PATH | sort -u'
fi

# Functions
_xdg_apps() {
    # Cache names and executable paths of XDG shortcuts.
    for file in $(printf '%s/*.desktop\n' "${xdg_paths[@]}"); do
        # Grab the friendly name and path of the executable (thanks, <geirha@freenode/#awk>).
        awk -F'=' '$1 == "Name" {sub(/Name=/, "", $0); name=$0}
                   $1 == "Exec" {sub(/Exec=/, "", $0); exec=$0}
                   END { print name "|" exec }' "$file" 2> /dev/null
    done
}

_build_list() {
    # Print the menu items, starting with XDG shortcut names...
    _xdg_apps | sed 's/|.*$//' | sort -u

    # Print the binary names by alphabet or atime.
    #IFS=':'; $lsx $PATH | sort -u
    echo $PATH | tr ':' '\n' | uniq | sed 's#$#/#' | xargs ls -lu --time-style=+%s | awk '/^(-|l)/ { print $6, $7 }' |  sort -rn | cut -d' ' -f 2
}


# Main
# Ask the user to select a program to launch.
selection=$(_build_list | dmenu)

# Exit if no selection
test -z "$selection" && exit 1

# Check if $selection is an executible or an XDG shortcut. If there's more than one, ask which binary to use.
app=$(type -p "$selection" 2>/dev/null) || app=$(grep -F "$selection|" <(_xdg_apps) | sed 's/.*|//;s/ %.//g') && test $(echo "$app" | wc -l) != 1 && app=$(echo "$app" | dmenu -p 'Which one?')
# Run the XDG executible.
test -n "$app" && exec "$app"

# Run in a terminal if ending in semi-colon.
test "$TERM" = "$(which st)" && TERM="st -e"
test "$selection" = "*\;" && exec "$TERM ${selection::-1}"

# Run the plain executible.
exec "$selection"
