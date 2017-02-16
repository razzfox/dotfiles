hc () {
  COMMANDS="$COMMANDS , $@"
}

# Frame Tiling Algorithms (index and name are used inconsistently)
# 0: vertical - clients are placed below each other
# 1: horizontal - clients are placed next to each other
# 2: max - all clients are maximized in this frame
# 3: grid - clients are arranged in an almost quadratic grid
# use 3: grid by default
hc set default_frame_layout 3
hc set_layout grid
# DOES NOT EXIST
#herbstclient get_attr tags.focus.frame_layout
#herbstclient substitute LAYOUT tags.focus.frame_layout emit_hook frame_layout LAYOUT


# Rules
# "--CONDITION=VALUE --CONSEQUENCE=VALUE" or "~" for regex
# "not --CONDITION" negates the CONDITION
# CONDITION: instance, class, title, pid, maxage=(sec), windowtype, windowrole
# CONSEQUENCE: tag, monitor, focus, switchtag, manage, index, pseudotile, ewmhrequests, ewmhnotify, fullscreen, hook, keymask
# instance: first 'xprop | grep WM_CLASS'
# class: second 'xprop | grep WM_CLASS'
# windowtype: 'xprop | grep _NET_WM_WINDOW_TYPE'
# windowrole: 'xprop | grep WM_WINDOW_ROLE'


# Defaults
hc unrule --all
# do not focus new clients by default
hc rule focus=off
# do not pseudotile frames by default
hc rule pseudotile=off

# Dialog/Pop-up boxes
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
#hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)|pop-up|GtkFileChooserDialog' pseudotile=on

# Apps
hc rule windowtype~'_NET_WM_STATE_FULLSCREEN' fullscreen=on
hc rule instance="guake" focus=on
hc rule instance="${TERMINAL:-st-256color}" focus=on


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
