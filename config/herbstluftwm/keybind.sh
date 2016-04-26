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
hc() {
  COMMANDS="$COMMANDS , $@"
}

Super=Mod4 # Super key
Mod=Mod1 # Alt/Option key
SCREENSAVER="spawn xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="spawn xset s off -dpms"
TERMINAL="spawn ${TERMINAL:-$(which dmenu_run)}"
TAG="spawn bash $HOME/.config/herbstluftwm/tags.sh"
DMENU_OPTIONS="-i -nf $( herbstclient get_attr settings.frame_border_inner_color ) -nb $( herbstclient get_attr settings.frame_bg_normal_color ) -sf $( herbstclient get_attr settings.frame_bg_normal_color ) -sb $( herbstclient get_attr settings.window_border_active_color )"
DMENU_LAUNCH="substitute MONITOR monitors.focus.index spawn bash $HOME/.config/herbstluftwm/dmenu_launch.sh $DMENU_OPTIONS -m MONITOR"
DMENU_RUN="substitute MONITOR monitors.focus.index spawn dmenu_run $DMENU_OPTIONS -m MONITOR"
DMENU_EXPLORE="substitute MONITOR monitors.focus.index spawn bash $HOME/.config/herbstluftwm/dmenu_explore.sh $DMENU_OPTIONS -m MONITOR"

# General Keys
hc keyunbind --all

hc keybind Super-Shift-q chain : emit_hook quit_panel : quit # can not use comma delimeter in the hc() chain already using comma.
hc keybind Super-r reload
hc keybind Super-Shift-r detect_monitors

hc keybind Super-t $TERMINAL
hc keybind Super-Shift-t $TERMINAL
# Enter key
hc keybind Super-Shift-Return $TERMINAL
hc keybind Super-space $DMENU_LAUNCH
hc keybind Super-Shift-space $DMENU_RUN
hc keybind Super-Control-space $DMENU_EXPLORE


# Mouse
hc mouseunbind --all
hc mousebind Shift-Button1 move
hc mousebind Control-Button1 resize
hc mousebind Super-Control-Button1 zoom


# Manage Tags
# both emits tag_added
hc keybind Super-c $TAG create
#substitute NAME tags.focus.name substitute ID clients.focus.winid substitute INDEX tags.focus.index
hc keybind Super-Shift-c substitute CLIENT clients.focus.instance chain : add CLIENT : move CLIENT : use CLIENT : $TAG update
# emits tag_removed
hc keybind Super-Shift-x substitute NAME tags.focus.name chain : use_index -1 : merge_tag NAME : $TAG update

# Focus Tags
# Done here initially, but then done on the fly with tags.sh
tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
tag_keys=( $( seq ${#tag_names[@]} ) )
for i in ${!tag_names[@]} ; do
    key="${tag_keys[$i]}"
    if ! [ -z "$key" ] ; then
        hc keybind Super-$key use_index $i
        hc keybind Super-Shift-$key substitute INDEX tags.focus.index chain : move_index $i : $TAG rename INDEX
    fi
done

hc keybind Super-period use_index +1
hc keybind Super-Shift-period substitute INDEX tags.focus.index chain : move_index +1 : $TAG rename_next INDEX
# fn-RightArrow
hc keybind Super-End use_index +1
hc keybind Super-Shift-End substitute INDEX tags.focus.index chain : move_index +1 : $TAG rename_next INDEX
hc keybind Super-comma use_index -1
hc keybind Super-Shift-comma substitute INDEX tags.focus.index chain : move_index -1 : $TAG rename_prev INDEX
# fn-LeftArrow
hc keybind Super-Home use_index -1
hc keybind Super-Shift-Home substitute INDEX tags.focus.index chain : move_index -1 : $TAG rename_prev INDEX
hc keybind Super-apostrophe use_previous
# does not emit tag_added nor tag_removed
# must create an inner chain for the inner substitute
#hc keybind Super-Shift-apostrophe chain : use_previous : substitute INDEX tags.focus.index chain . use_previous . move_index INDEX : emit_hook update_tags
hc keybind Super-Shift-apostrophe substitute ID clients.focus.winid chain : use_previous : bring ID : substitute INDEX tags.focus.index $TAG rename INDEX : use_previous

# Manage Windows
hc keybind Super-w close # close window

# Move Window
hc keybind Super-Shift-Left shift left
hc keybind Super-Shift-Down shift down
hc keybind Super-Shift-Up shift up
hc keybind Super-Shift-Right shift right

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
hc keybind Super-Control-Tab cycle_monitor


# Manage Frames
hc keybind Super-x remove

hc keybind Super-Alt-Left split left 0.5
hc keybind Super-Alt-Down split bottom 0.5
hc keybind Super-Alt-Up split top 0.5
hc keybind Super-Alt-Right split right 0.5
hc keybind Super-minus split bottom 0.5
hc keybind Super-backslash split right 0.5
hc keybind Super-Return split explode

hc keybind Super-f cycle_layout 1
hc keybind Super-Shift-f floating toggle
hc keybind Super-Control-f fullscreen toggle
hc keybind Super-Alt-f pseudotile toggle


# Media Keys
hc keybind XF86MonBrightnessDown emit_hook brightness	down # keycode:224
hc keybind Shift-XF86MonBrightnessDown emit_hook brightness	1
hc keybind XF86MonBrightnessUp emit_hook brightness	up # keycode:225
hc keybind Shift-XF86MonBrightnessUp emit_hook brightness	100

hc keybind XF86KbdLightOnOff emit_hook keybrightness   0
hc keybind Shift-XF86KbdLightOnOff emit_hook keybrightness   100
hc keybind XF86KbdBrightnessDown emit_hook keybrightness   down
hc keybind Shift-XF86KbdBrightnessDown emit_hook keybrightness   1
hc keybind XF86KbdBrightnessUp emit_hook keybrightness   up
hc keybind Shift-XF86KbdBrightnessUp emit_hook keybrightness   100

hc keybind XF86LaunchA emit_hook $DMENU_LAUNCH # keycode:120 Apple Expose
hc keybind Shift-XF86LaunchA emit_hook $DMENU_RUN # keycode:120 Apple Expose
hc keybind XF86LaunchB emit_hook dashboard # keycode:204 Apple Dashboard
hc keybind XF86LaunchB emit_hook dashboard # keycode:204 Apple Dashboard

hc keybind XF86AudioNext emit_hook play	next # keycode:163
hc keybind XF86AudioPlay emit_hook play	# keycode:164
hc keybind XF86AudioPrev emit_hook play	prev # keycode:165

hc keybind XF86AudioRaiseVolume emit_hook volume	up # keycode:115
hc keybind Shift-XF86AudioRaiseVolume emit_hook volume	+20 # keycode:115
hc keybind XF86AudioLowerVolume emit_hook volume	down # keycode:114
hc keybind Shift-XF86AudioLowerVolume emit_hook volume	-20 # keycode:114
hc keybind XF86AudioMute emit_hook volume	mute # keycode:113
hc keybind Shift-XF86AudioMute emit_hook volume	mute-input

hc keybind XF86Eject $SCREENSAVER # keycode:161
hc keybind Shift-XF86Eject $SCREENSAVEROFF # keycode:161
hc keybind XF86PowerOff brightness	0 # keycode:116

# Function Keys (these block other programs from receiving them)
hc keybind F1 emit_hook brightness   down
hc keybind Shift-F1 emit_hook brightness     1
hc keybind F2 emit_hook brightness     up
hc keybind Shift-F2 emit_hook brightness       100

#hc keybind F3 spawn true
#hc keybind F4 spawn true
#hc keybind F5 spawn true # keycode:63

hc keybind F6 emit_hook play	prev
hc keybind F7 emit_hook play
hc keybind F8 emit_hook play	next

hc keybind F9 emit_hook volume	mute
hc keybind F10 emit_hook volume	down
hc keybind F11 emit_hook volume	up

hc keybind F12 $SCREENSAVER
hc keybind Shift-F12 $SCREENSAVEROFF


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
