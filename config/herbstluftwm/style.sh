hc() {
  COMMANDS="$COMMANDS , $@"
}

DGRAY="#484848"
LGRAY="#909090"
BLUE="#2488F0"
GREEN="#02D645"
YELLOW="#FFBF00"
RED="#FF4645"

DBLUE="#0063cd"
LBLUE="#93cdff"
DGOLD="#ffaf18"
LGOLD="#ffe861"
DGRAPHITE="#577287"
LGRAPHITE="#b6c6d2"
DGREEN="#00bd3a"
LGREEN="#9afb80"
DORANGE="#ff6c16"
LORANGE="#ffc56e"
DPURPLE="#8837a9"
LPURPLE="#f5a5fe"
DRED="#ff1935"
LRED="#ff9b78"
DSILVER="#6c6c6c"
LSILVER="#bababa"

#C0C0C0 is a good choice but blends into window-chrome too often
#OLDACTIVE='#8080FF'
#OLDNORMAL='#303030'
#OLDURGENT='#FF8080'
#OLDINNER='#80FF80'


# General
hc set auto_detect_monitors 1
hc set_layout grid
hc set default_frame_layout 3 # grid
hc set tree_style 'X|:|`>-.'
hc set focus_crosses_monitor_boundaries 1
hc set focus_follows_mouse 1
hc set mouse_recenter_gap 0 # If the monitor is selected and the mouse position would be restored into this gap, it is set to the center of the monitor. If the gap is 0 (default), the mouse is never recentered.
#hc set wmname herbstluftwm


# Frames
hc set always_show_frame 1
hc set frame_gap 4 # show wallpaper between frames
# expand when only one frame exists, despite above two options
hc set smart_frame_surroundings 1

# These are zero so that windows can overlap their frame
# outer border color for FOCUS
hc set frame_border_width 0
hc set frame_border_active_color "$GREEN"
hc set frame_border_normal_color "$GREEN"
# inner is an always-on color for the border, despite active/normal/urgent settings
# must be less than border_width
hc set frame_border_inner_width 0
hc set frame_border_inner_color "#FFFFFF"

# Colors are shown in only an empty frame by its bg_color
hc set frame_padding 5 # push window inside
hc set frame_bg_transparent 1
hc set frame_transparent_width 1 # color width inside frame
hc set frame_bg_active_color "$YELLOW"
hc set frame_bg_normal_color "$DGRAY"
# show wallpaper inside frame box (noncompositing)
#hc set frame_active_opacity ? # wallpaper inside frame box (compositing)
#hc set frame_normal_opacity ? # wallpaper inside frame box (compositing)


# Windows
# space between windows in the same frame
# negative to expand over each other and the frame
# adds to or subtracts from frame_padding
hc set window_gap -5
# expand when only one window exists
hc set smart_window_surroundings 1

# outer border color for FOCUS
hc set window_border_width 1
hc set window_border_active_color "$BLUE"
hc set window_border_normal_color "$DGRAY"
hc set window_border_urgent_color "$RED"
# inner is an always-on color for the border, despite active/normal/urgent settings
# must be less than border_width
hc set window_border_inner_width 0
hc set window_border_inner_color "$LGRAY"


# Float Mode
# set to 0 to prevent 'manage=off' clients from being hidden ???
hc set raise_on_click 1
hc set raise_on_focus 0
hc set update_dragged_clients 0


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
