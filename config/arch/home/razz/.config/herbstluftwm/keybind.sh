#Modifier: Alt/Option (Mod1)
#               + Shift         + Control       + Super (Mod4)  [none]
#             ---------------------------------------------------------------
# /\,\/,<-,-> | (move-window)   (resize-frame)  (create-frame)  (focus-window)
# Backspace   |                                 (remove-frame)  (remove-frame)
# Tab         | (cycle-window)                                  (cycle-window)
# 1..0        | (assign-tag)                                    (current-tag)
# f key       | (floating)      (pseudo-tile)   (cycle-layout)  (fullscreen)
# q key       | (quit)
# r key       | (reload)
# x key       | (remove-tag)                                    (close-window)
# c key       | (create-tag)
# t key       | (terminal)
#
# No Modifier:
# spacebar    | (dmenu_run)                     (dmenu.sh)
# e key       |                                 (dmenu_explore.sh)

hc() {
  COMMANDS="$COMMANDS , $@"
}

Super=Mod4 # super key
Mod=Mod1 # alt/option key
SCREENSAVER="xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="xset s off -dpms"
TERMINAL="${TERMINAL:-$(which xterm)}"
TAG="bash $HOME/.config/herbstluftwm/tags.sh"
DMENU_LAUNCH="bash $HOME/.config/herbstluftwm/dmenu_launch.sh"
DMENU_EXPLORE="bash $HOME/.config/herbstluftwm/dmenu_explore.sh"


# General Keys
hc keyunbind --all

hc keybind $Mod-Shift-q chain : emit_hook quit_panel : quit # can not use comma delimeter in the hc() chain already using comma.
hc keybind $Mod-r reload

hc keybind $Mod-t spawn $TERMINAL
hc keybind $Mod-Shift-t spawn $TERMINAL
hc keybind $Mod-Shift-Return spawn $TERMINAL
hc keybind $Super-space spawn $DMENU_LAUNCH
hc keybind $Super-Shift-space spawn dmenu_run
hc keybind $Super-e spawn $DMENU_EXPLORE


# Media Keys
hc keybind XF86PowerOff brightness	0 # keycode:116
hc keybind XF86Eject spawn $SCREENSAVER # keycode:161
hc keybind Shift-XF86Eject spawn $SCREENSAVEROFF # keycode:161

hc keybind XF86AudioRaiseVolume emit_hook volume	up # keycode:115
hc keybind XF86AudioLowerVolume emit_hook volume	down # keycode:114
hc keybind XF86AudioMute emit_hook volume	mute # keycode:113
hc keybind Shift-XF86AudioMute emit_hook volume	mute-input

hc keybind XF86AudioNext emit_hook play	next # keycode:163
hc keybind XF86AudioPlay emit_hook play # keycode:164
hc keybind XF86AudioPrev emit_hook play	prev # keycode:165

#hc keybind XF86KbdBrightnessUp spawn true
#hc keybind XF86KbdBrightnessDown spawn true
#hc keybind XF86KbdLightOnOff spawn true

hc keybind XF86LaunchA emit_hook expose # keycode:120 Apple Expose
hc keybind XF86LaunchB emit_hook dashboard # keycode:204 Apple Dashboard
hc keybind XF86MonBrightnessUp emit_hook brightness	up # keycode:225
hc keybind Shift-XF86MonBrightnessUp emit_hook brightness	100
hc keybind XF86MonBrightnessDown emit_hook brightness	down # keycode:224
hc keybind Shift-XF86MonBrightnessDown emit_hook brightness	1

# Function Keys (these block other programs from receiving them)
#hc keybind F1 spawn true
#hc keybind F2 spawn true
#hc keybind F3 spawn true
#hc keybind F4 spawn true

#hc keybind F5 spawn true # keycode:63
#hc keybind F6 spawn true
#hc keybind F7 spawn true
#hc keybind F8 spawn true

hc keybind F9 spawn emit_hook volume    down
hc keybind Shift-F9 spawn emit_hook volume      mute
hc keybind F10 spawn  emit_hook volume  up
hc keybind F11 spawn $SCREENSAVER
hc keybind Shift-F11 spawn $SCREENSAVEROFF
#hc keybind F12 spawn true


# Manage Tags
hc keybind $Mod-c spawn $TAG create
hc keybind $Mod-Shift-x spawn $TAG delete

# Focus Tags
tag_names=( $(herbstclient tag_status 0) )
for i in $(seq --separator=' ' ${#tag_names[@]}); do
  hc keybind $Mod-${i:(-1)} use_index $(($i-1))
  hc keybind $Mod-Shift-${i:(-1)} move_index $(($i-1))
done

hc keybind $Mod-period use_index +1 --skip-visible
hc keybind $Mod-comma use_index -1 --skip-visible
hc keybind $Mod-End use_index +1 --skip-visible # fn-RightArrow
hc keybind $Mod-Home use_index -1 --skip-visible # fn-LeftArrow


# Manage Windows
hc keybind $Mod-x close # close window

# Move Window
hc keybind $Mod-Shift-Left shift left
hc keybind $Mod-Shift-Down shift down
hc keybind $Mod-Shift-Up shift up
hc keybind $Mod-Shift-Right shift right

# Resize Window
RESIZESTEP=0.025
hc keybind $Mod-Control-Left resize left +$RESIZESTEP
hc keybind $Mod-Control-Down resize down +$RESIZESTEP
hc keybind $Mod-Control-Up resize up +$RESIZESTEP
hc keybind $Mod-Control-Right resize right +$RESIZESTEP

# Focus Window
hc keybind $Mod-Left focus left
hc keybind $Mod-Down focus down
hc keybind $Mod-Up focus up
hc keybind $Mod-Right focus right

hc keybind $Mod-Tab cycle_all +1
hc keybind $Mod-Shift-Tab cycle_all -1
hc keybind $Mod-quote cycle_monitor # Shift-comma


# Manage Frames
hc keybind $Mod-$Super-Left split left 0.5
hc keybind $Mod-$Super-Down split bottom 0.5
hc keybind $Mod-$Super-Up split top 0.5
hc keybind $Mod-$Super-Right split right 0.5

hc keybind $Mod-x remove

hc keybind $Mod-f cycle_layout 1
hc keybind $Mod-Shift-f floating toggle
hc keybind $Mod-Control-f fullscreen toggle
hc keybind $Mod-$Super-f pseudotile toggle


# Mouse
hc mouseunbind --all
hc mousebind Shift-Button1 move
hc mousebind Control-Button1 resize
hc mousebind $Mod-Control-Button1 zoom


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
