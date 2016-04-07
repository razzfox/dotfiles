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

hc() {
  COMMANDS="$COMMANDS , $@"
}

Super=Mod4 # super key
Mod=Mod1 # alt/option key
SCREENSAVER="spawn xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="spawn xset s off -dpms"
TERMINAL="spawn ${TERMINAL:-$(which dmenu_run)}"
TAG="spawn bash $HOME/.config/herbstluftwm/tags.sh"
DMENU_LAUNCH="spawn bash $HOME/.config/herbstluftwm/dmenu_launch.sh"
DMENU_RUN="spawn dmenu_run"
DMENU_EXPLORE="spawn bash $HOME/.config/herbstluftwm/dmenu_explore.sh"

# General Keys
hc keyunbind --all

hc keybind $Super-Shift-q chain : emit_hook quit_panel : quit # can not use comma delimeter in the hc() chain already using comma.
hc keybind $Super-r reload
hc keybind $Super-Shift-r detect_monitors

hc keybind $Super-t $TERMINAL
hc keybind $Super-Shift-t $TERMINAL
# Enter key
hc keybind $Super-Shift-Return $TERMINAL
hc keybind $Super-space $DMENU_LAUNCH
hc keybind $Super-Shift-space $DMENU_RUN
hc keybind $Super-Control-space $DMENU_EXPLORE


# Mouse
hc mouseunbind --all
hc mousebind Shift-Button1 move
hc mousebind Control-Button1 resize
hc mousebind $Super-Control-Button1 zoom


# Manage Tags
hc keybind $Super-c $TAG create
hc keybind $Super-Shift-c $TAG break_out
hc keybind $Super-Shift-x $TAG delete

# Focus Tags
tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
tag_keys=( $( seq ${#tag_names[@]} ) )

hc rename default "${tag_names[0]}" || true
for i in ${!tag_names[@]} ; do
    key="${tag_keys[$i]}"
    if ! [ -z "$key" ] ; then
        hc keybind "$Super-$key" use_index "$i"
        hc keybind "$Super-Shift-$key" move_index "$i"
    fi
done

hc keybind $Super-period use_index +1 --skip-visible
hc keybind $Super-Shift-period move_index +1 --skip-visible
hc keybind $Super-End use_index +1 --skip-visible # fn-RightArrow
hc keybind $Super-Shift-End move_index +1 --skip-visible # fn-RightArrow
hc keybind $Super-comma use_index -1 --skip-visible
hc keybind $Super-Shift-comma move_index -1 --skip-visible
hc keybind $Super-Home use_index -1 --skip-visible # fn-LeftArrow
hc keybind $Super-Shift-Home move_index -1 --skip-visible # fn-LeftArrow
hc keybind $Super-apostrophe use_previous
hc keybind $Super-Shift-apostrophe move_previous

# Manage Windows
hc keybind $Super-w close # close window

# Move Window
hc keybind $Super-Shift-Left shift left
hc keybind $Super-Shift-Down shift down
hc keybind $Super-Shift-Up shift up
hc keybind $Super-Shift-Right shift right

# Resize Window
RESIZESTEP=0.025
hc keybind $Super-Control-Left resize left +$RESIZESTEP
hc keybind $Super-Control-Down resize down +$RESIZESTEP
hc keybind $Super-Control-Up resize up +$RESIZESTEP
hc keybind $Super-Control-Right resize right +$RESIZESTEP

# Focus Window
hc keybind $Super-Left focus left
hc keybind $Super-Down focus down
hc keybind $Super-Up focus up
hc keybind $Super-Right focus right

hc keybind $Super-Tab cycle_all +1
hc keybind $Super-Shift-Tab cycle_all -1
hc keybind $Super-Shift-apostrophe cycle_monitor


# Manage Frames
hc keybind $Super-x remove

hc keybind $Super-$Mod-Left split left 0.5
hc keybind $Super-$Mod-Down split bottom 0.5
hc keybind $Super-$Mod-Up split top 0.5
hc keybind $Super-$Mod-Right split right 0.5
hc keybind $Super-minus split bottom 0.5
hc keybind $Super-backslash split right 0.5
hc keybind $Super-Return split explode

hc keybind $Super-f cycle_layout 1
hc keybind $Super-Shift-f floating toggle
hc keybind $Super-Control-f fullscreen toggle
hc keybind $Super-$Mod-f pseudotile toggle


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
