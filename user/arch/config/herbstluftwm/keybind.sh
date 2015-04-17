#Modifier Key: Alt/Option
#               + Shift         + Control       + Super         [none]
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
# p key       | (dmenu_run)                                     (dmenu.sh)

hc() {
  COMMANDS="$COMMANDS , $@"
}

#Mod=Mod4 # use the super key
Mod=Mod1 # use alt/option
DMENU="bash $HOME/.config/herbstluftwm/dmenu.sh"
test -n "$TERM" || TERM="$DMENU"
SCREENSAVER="xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="xset s off -dpms"
TAG="dotfiles/user/arch/config/herbstluftwm/tags.sh"


# General Keys
hc keyunbind --all

hc keybind $Mod-Shift-q chain : emit_hook quit_panel : quit # can not use comma delimeter in the hc() chain already using comma.
hc keybind $Mod-r reload

hc keybind $Mod-t spawn $TERMINAL
hc keybind $Mod-Shift-t spawn $TERMINAL
hc keybind $Mod-Shift-Return spawn $TERMINAL
hc keybind $Mod-p spawn $DMENU
hc keybind $Mod-Shift-p spawn dmenu_run


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

#hc keybind XF86KbdBrightnessUp
#hc keybind XF86KbdBrightnessDown
#hc keybind XF86KbdLightOnOff

hc keybind XF86LaunchA emit_hook expose # keycode:120 Apple Expose
hc keybind XF86LaunchB emit_hook dashboard # keycode:204 Apple Dashboard

hc keybind XF86MonBrightnessUp emit_hook brightness	up # keycode:225
hc keybind Shift-XF86MonBrightnessUp emit_hook brightness	100
hc keybind XF86MonBrightnessDown emit_hook brightness	down # keycode:224
hc keybind Shift-XF86MonBrightnessDown emit_hook brightness	1

# Function Keys
#hc keybind F1 spawn true
#hc keybind F2 spawn true
#hc keybind F3 spawn true
#hc keybind F4 spawn true
#hc keybind F5 spawn true # keycode:63
#hc keybind F6 spawn true
#hc keybind F7 spawn true
#hc keybind F8 spawn true
#hc keybind F9 spawn true
#hc keybind F10 spawn true
#hc keybind F11 spawn true
#hc keybind F12 spawn true


# Manage Tags
hc keybind $Mod-c spawn $TAG create
hc keybind $Mod-Shift-x spawn $TAG create

# Focus Tags
tag_names=( $(herbstclient tag_status 0) )
for i in $(seq --separator=' ' ${#tag_names[@]}); do
  hc keybind Mod1-${i:(-1)} use_index $(($i-1))
  hc keybind Mod1-Shift-${i:(-1)} move_index $(($i-1))
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
hc keybind $Mod-grave cycle_monitor


# Manage Frames
hc keybind $Mod-Mod4-Left split left 0.5
hc keybind $Mod-Mod4-Down split bottom 0.5
hc keybind $Mod-Mod4-Up split top 0.5
hc keybind $Mod-Mod4-Right split right 0.5

hc keybind $Mod-x remove

hc keybind $Mod-f cycle_layout 1
hc keybind $Mod-Shift-f floating toggle
hc keybind $Mod-Control-f pseudotile toggle
hc keybind $Mod-Mod4-f fullscreen toggle


# Mouse
hc mouseunbind --all
hc mousebind Shift-Button1 move
hc mousebind Control-Button1 resize
hc mousebind $Mod-Control-Button1 zoom


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
