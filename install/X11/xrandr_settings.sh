# In multi-monitor situations, you will probably need to run some xrandr settings. To make this change permanent simply place the xrandr command before 'exec' in your '.xinitrc'.

# For example, considering a laptop with an external monitor to the right of it, the following command would 'extend' the display (rather than the default mirroring), and set the correct resolution for both displays:
#xrandr --auto --output LVDS --primary --mode 1366x768 --left-of VGA-0 --output VGA-0 --mode 1280x1024

# To determine your optimal resolutions and display names, simply run:
xrandr -q
