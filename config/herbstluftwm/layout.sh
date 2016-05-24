


hc () {
  COMMANDS="$COMMANDS , $@"
}

tag_names=( )

# Create Tags
## Tag actions must be atomic, not chained together
herbstclient rename default "${tag_names[0]}" || true
for i in ${!tag_names[@]} ; do
  herbstclient add "${tag_names[$i]}"
done


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

# Rules
hc unrule --all
# do not focus new clients by default
hc rule focus=off
# do not pseudotile frames by default
hc rule pseudotile=off


# Popups
#hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off

#hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' pseudotile=on
#hc rule windowrole="pop-up" pseudotile=on
#hc rule windowrole="GtkFileChooserDialog" pseudotile=on

# Applications
hc rule windowtype~'_NET_WM_STATE_FULLSCREEN' fullscreen=on
#hc rule class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on # give focus to most common terminals
hc rule instance="guake" focus=on
hc rule instance="st-256color" focus=on
#hc rule instance="Google-chrome-stable" tag=WEB
#hc rule windowrole="pop-up" class="Google-chrome-stable" tag=WEB
#hc rule title="Atom" tag=DEV
#hc rule instance="subl3" tag=DEV
#hc rule class="Mplayer" tag=MEDIA
#hc rule class="Ranger" tag=MEDIA
#hc rule class="VirtualBox" tag=OTHER
#hc rule instance="gimp" tag=OTHER


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
