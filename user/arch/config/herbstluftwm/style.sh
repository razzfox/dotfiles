hc() {
  COMMANDS="$COMMANDS , $@"
}

# General
hc set auto_detect_monitors 1
hc set_layout grid
hc set default_frame_layout 3 # grid
hc set tree_style 'X|:|`>-.'
hc set focus_crosses_monitor_boundaries 1
hc set focus_follows_mouse 1
hc set mouse_recenter_gap 0 # If the monitor is selected and the mouse position would be restored into this gap, it is set to the center of the monitor. If the gap is 0 (default), the mouse is never recentered.
#hc set wmname herbstluftwm


# Windows
hc set window_gap -4 # overlap window borders

hc set window_border_width 2
hc set window_border_active_color '#8080FF' # #C0C0C0 is a good choice but blends into window-chrome too often
hc set window_border_normal_color '#303030'
hc set window_border_urgent_color '#FF8080'

hc set window_border_inner_width 0 # must be less than border_width
hc set window_border_inner_color '#80FF80'


# Frames
hc set always_show_frame 1
hc set frame_gap 4 # show wallpaper between frames

hc set frame_bg_active_color '#8080FF'
hc set frame_bg_normal_color '#303030'
hc set frame_bg_transparent 1 # show wallpaper inside frame box (noncompositing)
#hc set frame_active_opacity ? # wallpaper inside frame box (compositing)
#hc set frame_normal_opacity ? # wallpaper inside frame box (compositing)
hc set frame_transparent_width 6 # color width inside frame
hc set frame_padding 2 # push window inside

hc set frame_border_width 2 # outer frame border
hc set frame_border_active_color '#8080FF'
hc set frame_border_normal_color '#303030'

# inner is an always-on color for the border, despite active/normal/urgent settings
hc set frame_border_inner_width 0 # must be less than border_width
hc set frame_border_inner_color '#80FF80'

hc set smart_frame_surroundings 1 # expand when only one frame exists
hc set smart_window_surroundings 1 # expand when only one window exists


# Float Mode
# set to 0 to prevent 'manage=off' clients from being hidden ???
hc set raise_on_click 1
hc set raise_on_focus 0
hc set update_dragged_clients 0


# Chain commands
herbstclient chain $COMMANDS
unset COMMANDS
