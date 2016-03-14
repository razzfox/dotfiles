# Rules
# "--CONDITION=VALUE --CONSEQUENCE=VALUE" or "~" for regex
# "not --CONDITION" negates the CONDITION
# CONDITION: instance, class, title, pid, maxage=(sec), windowtype, windowrole
# CONSEQUENCE: tag, monitor, focus, switchtag, manage, index, pseudotile, ewmhrequests, ewmhnotify, fullscreen, hook, keymask
# instance: first 'xprop | grep WM_CLASS'
# class: second 'xprop | grep WM_CLASS'
# windowtype: 'xprop | grep _NET_WM_WINDOW_TYPE'
# windowrole: 'xprop | grep WM_WINDOW_ROLE'

hc() {
  COMMANDS="$COMMANDS , $@"
}

unset tag_names
#tag_names=( WEB TERM DEV )
#tag_names+=( $@ )
tag_names=( {1..9} )


## Tag actions must be atomic, not chained together
herbstclient lock

# Create Tags
herbstclient rename default "${tag_names[0]}" || true
for i in ${!tag_names[@]} ; do
  herbstclient add "${tag_names[$i]}"
done

## End atomic tag actions
herbstclient unlock


# Rules
hc unrule --all
hc rule focus=off # normally do not focus new clients

# Popups
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(UTILITY|SPLASH)' pseudotile=on
hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK)' manage=off
hc rule windowtype~'_NET_WM_STATE_FULLSCREEN' fullscreen=on
hc rule windowrole="pop-up" pseudotile=on
hc rule windowrole="GtkFileChooserDialog" pseudotile=on

# Applications
hc rule class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on # give focus to most common terminals
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
