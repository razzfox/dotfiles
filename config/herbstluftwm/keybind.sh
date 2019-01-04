# Key         | Super/Mod4      + Shift         + Control
#-------------|-------------------------------------------------------------
# /\,\/,<-,-> | (focus-window)  (move-window)   (resize-frame)              
# [ < ][ > ]  | (focus-tag-next) (assign-window-tag-next) (focus-monitor)
#                                (assign-window-monitor-next)

# Enter       | (create-frame)  (terminal)                                  
# [C]         | (create-tag)    (create-tag-for-window)                     
# [X]         | (remove-frame)  (remove-tag)                                
# [W]         |                 (close-window)

### Layout ###
# [O]         | (rotate-frames) (rotate-frames-reverse)
# [F]         | (fullscreen)    (floating)      (pseudotile)

#### Tags ####
# [1]..[0]    | (focus-tag-N)   (assign-window-tag-N)                       
# Tab         | (focus-tag-cycle) (focus-tag-cycle-reverse)                  
# [ ' ][ " ]  | (focus-tag-prev) (assign-window-tag-prev)                    

### General ###
# space       | (dmenu_run)     (create-tag-dmenu) (dmenu_explore.sh)
# [Q]         |                 (quit-hlwm)     (quit-panel)
# [R]         |                 (reload-hlwm)   (reload-monitors)


# The separator here must be separate from the separator used below, so it can run a chain inside a chain
hc () {
  COMMANDS="$COMMANDS , $@"
}

# These may be for keeping consistency between different keyboards (which may swap alt and super)
#Mod=Mod4 # Super key
#Mod=Mod1 # Alt/Option key

SCREENSAVERON="xset -display :0 dpms force off" # Works best as a single key (not combo) because key-release events will reactivate the screen
SCREENSAVEROFF="xset s off -dpms"
SCREENON="chain : emit_hook brightness 100 : emit_hook keybrightness 100"
SUSPEND="systemctl suspend"
POWER="chain : emit_hook brightness power : emit_hook keybrightness power"

TERMINAL="${TERMINAL:-$(which dmenu_run)}"

CPUMONITOR="$TERMINAL -e htop"
NETWORKMONITOR="$TERMINAL -e vnstat -l -ru -i $( ip link | grep 'state UP' | cut -d: -f 2 )"
IOMONITOR="$TERMINAL -e sudo iotop --only --processes --accumulated"

DMENU_OPTIONS="-i $( $panel_top || echo '-b' ) -nf $( herbstclient get_attr settings.frame_border_inner_color ) -nb $( herbstclient get_attr settings.frame_bg_normal_color ) -sf $( herbstclient get_attr settings.frame_bg_normal_color ) -sb $( herbstclient get_attr settings.window_border_active_color )"
DMENU_LAUNCH="bash $HOME/.config/herbstluftwm/dmenu_launch.sh $DMENU_OPTIONS"
DMENU_EXPLORE="bash $HOME/.config/herbstluftwm/dmenu_explore.sh $DMENU_OPTIONS"

CLIPMENU="clipmenu"


# General
hc keyunbind --all
# can not use comma delimeter in the hc() chain already using comma.
hc keybind Super-Shift-q chain : emit_hook quit_panel : quit
hc keybind Super-Control-q emit_hook quit_panel
# reload hook also reloads panel
hc keybind Super-Shift-r reload
hc keybind Super-Control-r detect_monitors


# Clipboard
hc keybind Super-k spawn $CLIPMENU


# Add Window
# New Terminal (shell)
hc keybind Super-Shift-Return spawn $TERMINAL
hc keybind Super-Shift-Enter spawn $TERMINAL
hc keybind Control-Shift-Return spawn $TERMINAL

# Launch App
hc keybind Super-space substitute MONITOR monitors.focus.index spawn $DMENU_LAUNCH -m MONITOR

# New Tag and Launch App
hc keybind Super-Shift-space substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT " : spawn $DMENU_LAUNCH

# File Explorer
hc keybind Super-Control-space spawn $DMENU_EXPLORE


# Mouse (Floating mode)
hc mouseunbind --all
hc mousebind Super-Shift-Button1 move
hc mousebind Super-Control-Button1 resize
hc mousebind Super-Shift-Control-Button1 zoom


# Add Tag (emits tag_added)
hc keybind Super-c substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT "
hc keybind Super-Shift-c substitute CLIENT clients.focus.instance chain : add CLIENT : move CLIENT : use CLIENT


# Remove Tag (emits tag_removed)
hc keybind Super-Shift-x substitute NAME tags.focus.name chain : use_index -1 : merge_tag NAME


# Focus Tags
# Done here initially and on reload, but also done via hooks in panel.sh
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

# To mirror browser tab behavior
hc keybind Super-Tab use_index +1
hc keybind Super-Shift-Tab use_index -1


# Focus Monitors
monitor_names=( $( herbstclient list_monitors ) )
monitor_keys=( $( seq ${#monitor_names[@]} ) )
for i in ${!monitor_names[@]} ; do
    key="${monitor_keys[$i]}"
    if ! [ -z "$key" ] ; then
        hc keybind Super-Control-$key focus_monitor $i
        hc keybind Super-Control-Shift-$key shift_to_monitor $i
    fi
done

hc keybind Super-Control-comma cycle_monitor -1
hc keybind Super-Control-period cycle_monitor +1
hc keybind Super-Control-Shift-comma shift_to_monitor -1
hc keybind Super-Control-Shift-period shift_to_monitor +1


# Remove Window
#hc keybind Super-Shift-w close
hc keybind Super-Shift-w close_and_remove


# Focus Window
hc keybind Super-Up focus up
hc keybind Super-Down focus down
hc keybind Super-Left focus left
hc keybind Super-Right focus right

# Changed to tag
#hc keybind Super-Tab cycle_all +1
#hc keybind Super-Shift-Tab cycle_all -1


# Move Window between Frames
hc keybind Super-Shift-Up shift up
hc keybind Super-Shift-Down shift down
hc keybind Super-Shift-Left shift left
hc keybind Super-Shift-Right shift right


# Add Frame
hc keybind Super-Return split explode
hc keybind Super-minus split bottom 0.5
hc keybind Super-backslash split right 0.5

# Depreciated (tmux uses alt as modifier, try to reduce overlap, since intent is ambiguous)
# hc keybind Super-Alt-Up split top 0.5
# hc keybind Super-Alt-Down split bottom 0.5
# hc keybind Super-Alt-Left split left 0.5
# hc keybind Super-Alt-Right split right 0.5


# Remove Frame
hc keybind Super-x remove


# Resize Frame
RESIZESTEP=0.025
hc keybind Super-Control-Up resize up +$RESIZESTEP
hc keybind Super-Control-Down resize down +$RESIZESTEP
hc keybind Super-Control-Left resize left +$RESIZESTEP
hc keybind Super-Control-Right resize right +$RESIZESTEP


# Frame Layout inside Monitor
#hc keybind Super-f chain : cycle_layout +1 : emit_hook cycle_layout +1
hc keybind Super-f fullscreen toggle
hc keybind Super-Shift-f chain : floating toggle : substitute BOOLEAN tags.focus.floating substitute INDEX tags.focus.index emit_hook floating BOOLEAN INDEX
# emits fullscreen hook with string on/off (not true/false) and winid
hc keybind Super-Control-f chain : pseudotile toggle : substitute BOOLEAN clients.focus.pseudotile substitute WINID clients.focus.winid emit_hook pseudotile BOOLEAN WINID


# Rotate Frames inside Monitor
hc keybind Super-o chain : lock : rotate : rotate : rotate : unlock
hc keybind Super-Shift-o rotate


# Media Keys
# keycode:224
hc keybind XF86MonBrightnessDown emit_hook brightness down
hc keybind Shift-XF86MonBrightnessDown emit_hook brightness 1
# keycode:225
hc keybind XF86MonBrightnessUp emit_hook brightness up
hc keybind Shift-XF86MonBrightnessUp emit_hook brightness 100

hc keybind XF86KbdLightOnOff emit_hook keybrightness toggle
hc keybind Shift-XF86KbdLightOnOff emit_hook keybrightness toggle
hc keybind XF86KbdBrightnessDown emit_hook keybrightness down
hc keybind Shift-XF86KbdBrightnessDown emit_hook keybrightness 1
hc keybind XF86KbdBrightnessUp emit_hook keybrightness up
hc keybind Shift-XF86KbdBrightnessUp emit_hook keybrightness 100

# keycode:120 Apple Expose
hc keybind XF86LaunchA spawn $CPUMONITOR
hc keybind Shift-XF86LaunchA spawn $NETWORKMONITOR
hc keybind Control-XF86LaunchA spawn $IOMONITOR
# keycode:204 Apple Mission Control (Dashboard on older keyboards)
hc keybind XF86LaunchB spawn $DMENU_LAUNCH
hc keybind Shift-XF86LaunchB substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT " : spawn $DMENU_LAUNCH

# keycode:163
hc keybind XF86AudioNext emit_hook play next
# keycode:164
hc keybind XF86AudioPlay emit_hook play
# keycode:165
hc keybind XF86AudioPrev emit_hook play prev

# keycode:115
hc keybind XF86AudioRaiseVolume emit_hook volume up
hc keybind Shift-XF86AudioRaiseVolume emit_hook volume +20
# keycode:114
hc keybind XF86AudioLowerVolume emit_hook volume down
hc keybind Shift-XF86AudioLowerVolume emit_hook volume -20
# keycode:113
hc keybind XF86AudioMute emit_hook volume mute
hc keybind Shift-XF86AudioMute emit_hook volume mute-input

# keycode:161
hc keybind XF86Eject spawn $SUSPEND
#hc keybind Shift-XF86Eject spawn $SCREENSAVEROFF

# keycode:116
hc keybind XF86PowerOff $POWER
hc keybind Shift-XF86PowerOff $SCREENON


# Function Keys (these block other programs from receiving them)
hc keybind Super-F1 emit_hook brightness down
hc keybind Super-Shift-F1 emit_hook brightness 1
hc keybind Super-F2 emit_hook brightness up
hc keybind Super-Shift-F2 emit_hook brightness 100

hc keybind Super-F3 spawn $CPUMONITOR
hc keybind Super-Shift-F3 spawn $NETWORKMONITOR
hc keybind Super-Control-F3 spawn $IOMONITOR
hc keybind Super-F4 spawn $DMENU_LAUNCH
hc keybind Super-Shift-F4 substitute COUNT tags.count chain : add " 0 COUNT " : use " 0 COUNT " : spawn $DMENU_LAUNCH

# keycode:63
#hc keybind Super-F5 spawn true
#hc keybind Super-Shift-F5 spawn true
#hc keybind Super-F6 spawn true
#hc keybind Super-Shift-F6 spawn true

hc keybind Super-F7 emit_hook play prev
hc keybind Super-Shift-F7 emit_hook play -15
hc keybind Super-F8 emit_hook play
hc keybind Super-Shift-F7 emit_hook play stop
hc keybind Super-F9 emit_hook play next
hc keybind Super-Shift-F9 emit_hook play +15

hc keybind Super-F10 emit_hook volume mute
hc keybind Super-Shift-F10 emit_hook volume mute-input
hc keybind Super-F11 emit_hook volume down
hc keybind Super-Shift-F11 emit_hook volume 0
hc keybind Super-F12 emit_hook volume up
hc keybind Super-Shift-F12 emit_hook volume 100

hc keybind Super-Break $SUSPEND
#hc keybind Super-Shift-Break $SCREENSAVEROFF

# Macbook layout?
# hc keybind Super-F6 emit_hook play prev
# hc keybind Super-F7 emit_hook play
# hc keybind Super-F8 emit_hook play next
#
# hc keybind Super-F9 emit_hook volume mute
# hc keybind Super-Shift-F9 emit_hook volume mute-input
# hc keybind Super-F10 emit_hook volume down
# hc keybind Super-Shift-F10 emit_hook volume 0
# hc keybind Super-F11 emit_hook volume up
# hc keybind Super-Shift-F11 emit_hook volume 100
#
# hc keybind Super-F12 $SCREENOFF
# hc keybind Super-Shift-F12 $SCREENON

#A1048 iMac Keyboard
# hc keybind Super-F9 emit_hook volume mute
# hc keybind Super-Shift-F9 emit_hook volume mute-input
# hc keybind Super-F10 emit_hook volume down
# hc keybind Super-Shift-F10 emit_hook volume 0
# hc keybind Super-F11 emit_hook volume up
# hc keybind Super-Shift-F11 emit_hook volume 100

# hc keybind Super-F12 $SCREENOFF
# hc keybind Super-Shift-F12 $SCREENON
#hc keybind Super-Break $SUSPEND


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
