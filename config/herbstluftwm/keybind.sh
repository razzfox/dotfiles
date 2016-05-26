# Super/Mod4  | + Shift         + Control       + Alt/Option    [none]
#-------------|---------------------------------------------------------------
# /\,\/,<-,-> | (move-window)   (resize-frame)  (create-frame)  (focus-window)
# Backspace   |                                 (remove-frame)  (remove-frame)
# Tab         | (cycle-window)                                  (cycle-window)
# 1..0        | (assign-tag)                                    (current-tag)
# f key       | (floating)      (pseudo-tile)   (cycle-layout)  (fullscreen)
# q key       | (quit)
# r key       | (reload)
# x key       | (delete-tag)                                    (close-window)
# c key       | (create-tag)
# t / Enter   | (terminal)
# space       | (dmenu_run)     (dmenu_explore.sh)  (dmenu.sh)
# e key       |

# The separator here must be separate from the separator used below, so it can run a chain inside a chain
hc () {
  COMMANDS="$COMMANDS , $@"
}

Super=Mod4 # Super key
Mod=Mod1 # Alt/Option key

SCREENSAVER="spawn xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="spawn xset s off -dpms"
SCREENOFF="chain : emit_hook keybrightness 0 : emit_hook brightness 0"
SCREENON="chain : emit_hook brightness 100 : emit_hook keybrightness 100"

TERMINAL="spawn ${TERMINAL:-$(which dmenu_run)}"

DMENU_OPTIONS="-i -nf $( herbstclient get_attr settings.frame_border_inner_color ) -nb $( herbstclient get_attr settings.frame_bg_normal_color ) -sf $( herbstclient get_attr settings.frame_bg_normal_color ) -sb $( herbstclient get_attr settings.window_border_active_color )"
DMENU_LAUNCH="substitute MONITOR monitors.focus.index spawn bash $HOME/.config/herbstluftwm/dmenu_launch.sh $DMENU_OPTIONS -m MONITOR"
DMENU_EXPLORE="substitute MONITOR monitors.focus.index spawn bash $HOME/.config/herbstluftwm/dmenu_explore.sh $DMENU_OPTIONS -m MONITOR"

# General Keys
hc keyunbind --all

hc keybind Super-Shift-q chain : emit_hook quit_panel : quit # can not use comma delimeter in the hc() chain already using comma.
hc keybind Super-r reload
hc keybind Super-Shift-r detect_monitors

# Enter key
hc keybind Super-Shift-Return $TERMINAL
hc keybind Super-space $DMENU_LAUNCH
hc keybind Super-Shift-space substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT " : $DMENU_LAUNCH
hc keybind Super-Control-space $DMENU_EXPLORE


# Mouse
hc mouseunbind --all
hc mousebind Super-Shift-Button1 move
hc mousebind Super-Control-Button1 resize
hc mousebind Super-Shift-Control-Button1 zoom


# Manage Tags
# both emits tag_added
# hc keybind Super-c emit_hook tag_create
hc keybind Super-c substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT "
hc keybind Super-Shift-c substitute CLIENT clients.focus.instance chain : add CLIENT : move CLIENT : use CLIENT
# emits tag_removed
hc keybind Super-Shift-x substitute NAME tags.focus.name chain : use_index -1 : merge_tag NAME

# Focus Tags
# Done here initially and on reload, but also done on the fly with tag() in panel.sh
tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
tag_keys=( $( seq ${#tag_names[@]} ) )
for i in ${!tag_names[@]} ; do
    key="${tag_keys[$i]}"
    if ! [ -z "$key" ] ; then
        hc keybind Super-$key use_index $i
        hc keybind Super-Shift-$key chain : move_index $i : emit_hook rename_index $i
    fi
done

hc keybind Super-period use_index +1
hc keybind Super-Shift-period substitute INDEX tags.focus.index substitute COUNT tags.count chain : move_index +1 : emit_hook rename_index INDEX +1 COUNT
# fn-RightArrow
hc keybind Super-End use_index +1
hc keybind Super-Shift-End substitute INDEX tags.focus.index substitute COUNT tags.count chain : move_index +1 : emit_hook rename_index INDEX +1 COUNT
hc keybind Super-comma use_index -1
hc keybind Super-Shift-comma substitute INDEX tags.focus.index substitute COUNT tags.count chain : move_index -1 : emit_hook rename_index INDEX -1 COUNT
# fn-LeftArrow
hc keybind Super-Home use_index -1
hc keybind Super-Shift-Home substitute INDEX tags.focus.index substitute COUNT tags.count chain : move_index -1 : emit_hook rename_index INDEX -1 COUNT
hc keybind Super-apostrophe use_previous
# does not emit tag_added nor tag_removed
hc keybind Super-Shift-apostrophe substitute WINID clients.focus.winid chain : use_previous : bring WINID : substitute INDEX tags.focus.index emit_hook rename_index INDEX : use_previous

# Manage Windows
hc keybind Super-w close
hc keybind Super-Shift-w close_and_remove

# Move Window
hc keybind Super-Shift-Left shift left
hc keybind Super-Shift-Down shift down
hc keybind Super-Shift-Up shift up
hc keybind Super-Shift-Right shift right
hc keybind Super-o chain : lock : rotate : rotate : rotate : unlock
hc keybind Super-Shift-o rotate


# Resize Window
RESIZESTEP=0.025
hc keybind Super-Control-Left resize left +$RESIZESTEP
hc keybind Super-Control-Down resize down +$RESIZESTEP
hc keybind Super-Control-Up resize up +$RESIZESTEP
hc keybind Super-Control-Right resize right +$RESIZESTEP

# Focus Window
hc keybind Super-Left focus left
hc keybind Super-Down focus down
hc keybind Super-Up focus up
hc keybind Super-Right focus right

hc keybind Super-Tab cycle_all +1
hc keybind Super-Shift-Tab cycle_all -1
hc keybind Super-Control-Tab cycle_monitor +1


# Manage Frames
hc keybind Super-x remove

hc keybind Super-Return split explode
hc keybind Super-Alt-Up split top 0.5
hc keybind Super-Alt-Down split bottom 0.5
hc keybind Super-minus split bottom 0.5
hc keybind Super-Alt-Left split left 0.5
hc keybind Super-Alt-Right split right 0.5
hc keybind Super-backslash split right 0.5

hc keybind Super-f chain : cycle_layout +1 : emit_hook cycle_layout +1
hc keybind Super-Alt-f chain : pseudotile toggle : substitute BOOLEAN clients.focus.pseudotile substitute WINID clients.focus.winid emit_hook pseudotile BOOLEAN WINID
hc keybind Super-Shift-f chain : floating toggle : substitute BOOLEAN tags.focus.floating substitute INDEX tags.focus.index emit_hook floating BOOLEAN INDEX
# emits fullscreen hook with on/off (not true/false) and winid
hc keybind Super-Control-f fullscreen toggle


# Media Keys
hc keybind XF86MonBrightnessDown emit_hook brightness down # keycode:224
hc keybind Shift-XF86MonBrightnessDown emit_hook brightness 1
hc keybind XF86MonBrightnessUp emit_hook brightness up # keycode:225
hc keybind Shift-XF86MonBrightnessUp emit_hook brightness 100

hc keybind XF86KbdLightOnOff emit_hook keybrightness toggle
hc keybind Shift-XF86KbdLightOnOff emit_hook keybrightness toggle
hc keybind XF86KbdBrightnessDown emit_hook keybrightness down
hc keybind Shift-XF86KbdBrightnessDown emit_hook keybrightness 1
hc keybind XF86KbdBrightnessUp emit_hook keybrightness up
hc keybind Shift-XF86KbdBrightnessUp emit_hook keybrightness 100

hc keybind XF86LaunchA $DMENU_LAUNCH # keycode:120 Apple Expose
hc keybind Shift-XF86LaunchA substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT " : $DMENU_LAUNCH # keycode:120 Apple Expose
hc keybind XF86LaunchB $TERMINAL -e htop # keycode:204 Apple Dashboard
hc keybind Shift-XF86LaunchB $TERMINAL -e vnstat -l -ru -i $( ip link | grep "wlp" | cut -d: -f 2 ) # keycode:204 Apple Dashboard

hc keybind XF86AudioNext emit_hook play next # keycode:163
hc keybind XF86AudioPlay emit_hook play # keycode:164
hc keybind XF86AudioPrev emit_hook play prev # keycode:165

hc keybind XF86AudioRaiseVolume emit_hook volume up # keycode:115
hc keybind Shift-XF86AudioRaiseVolume emit_hook volume +20 # keycode:115
hc keybind XF86AudioLowerVolume emit_hook volume down # keycode:114
hc keybind Shift-XF86AudioLowerVolume emit_hook volume -20 # keycode:114
hc keybind XF86AudioMute emit_hook volume mute # keycode:113
hc keybind Shift-XF86AudioMute emit_hook volume mute-input

hc keybind XF86Eject $SCREENSAVER # keycode:161
hc keybind Shift-XF86Eject $SCREENSAVEROFF # keycode:161

hc keybind XF86PowerOff $SCREENOFF # keycode:116
hc keybind Shift-XF86PowerOff $SCREENON # keycode:116


# Function Keys (these block other programs from receiving them)
hc keybind F1 emit_hook brightness down
hc keybind Shift-F1 emit_hook brightness 1
hc keybind F2 emit_hook brightness up
hc keybind Shift-F2 emit_hook brightness 100

#hc keybind F3 spawn true
#hc keybind Shift-F3 spawn true
#hc keybind F4 spawn true
#hc keybind Shift-F4 spawn true
#hc keybind F5 spawn true # keycode:63
#hc keybind Shift-F5 spawn true # keycode:63

hc keybind F6 emit_hook play prev
hc keybind F7 emit_hook play
hc keybind F8 emit_hook play next

hc keybind F9 emit_hook volume mute
hc keybind Shift-F9 emit_hook volume mute-input
hc keybind F10 emit_hook volume down
hc keybind Shift-F10 emit_hook volume 0
hc keybind F11 emit_hook volume up
hc keybind Shift-F11 emit_hook volume 100

hc keybind F12 $SCREENOFF
hc keybind Shift-F12 $SCREENON


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
