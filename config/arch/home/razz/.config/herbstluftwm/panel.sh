#!/bin/bash
# TODO: edit the panel-daemon so that it uses an array containing the hooks (and layout), which can be live added or removed (on reload).

# Geometry
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") ) # formatted W H X Y
[ -z "$geometry" ] && echo "Invalid monitor $monitor" && exit 1
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}

panel_height=$2
herbstclient pad $monitor $panel_height

# Theme
font='-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*'
bordercolor='#26221C'
fgcolor='#efefef'
bgcolor="$(herbstclient get frame_border_normal_color)" #bgcolor='#303030'
selfg='#101010'
selbg="$(herbstclient get window_border_active_color)" #selbg='#8080FF'
separator="^bg()^fg($selbg)|"
textcolor='#909090'
flashcolor='#ff0675' #'#ef9090'

# Variables
getbat="bash $DOTFILES/shell/bat.arch"
# Possible commands: up down mute mute_source <num>
getvol="bash $DOTFILES/shell/vl.arch"
getbr="bash $DOTFILES/shell/br.arch"

# Initialize vars
battery='00.0%'
volume="$($getvol)"
brightness="$($getbr)"
visible='true'
windowtitle="$(herbstclient stack | grep -F -A1 Focus-Layer | tail -n 1 | cut -d '"' -f 2 | grep -F -v Fullscreen-Layer)"
IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"

# Functions
getdate() { # have so many problems with this, so I made a function
  date +"^fg($fgcolor)%I:%M^fg($textcolor), %Y-%m-^fg($fgcolor)%d"
}

setflash() {
  if test $# == 0; then
    herbstclient emit_hook $(echo -ne "flash\t") 2>/dev/null || break
  else
    for i in {0..13}; do
      herbstclient emit_hook $(echo -ne "flash\t^fg($fgcolor) $@ $separator") 2>/dev/null || break
      sleep 1
      herbstclient emit_hook $(echo -ne "flash\t^fg($flashcolor) $@ $separator") 2>/dev/null || break
      sleep 1
    done
  fi
}

draw_tags() {
  for i in "${tags[@]}"; do
    case ${i:0:1} in
      '#')
      echo -n "^bg($selbg)^fg($selfg)"
      ;;
      '+')
      echo -n "^bg(#9CA668)^fg(#141414)"
      ;;
      ':')
      echo -n "^bg()^fg(#ffffff)"
      ;;
      '!')
      echo -n "^bg(#FF0675)^fg(#141414)"
      ;;
      *)
      echo -n "^bg()^fg(#ababab)"
      ;;
    esac
    # clickable tags if using SVN dzen
    echo -n "^ca(1,\"herbstclient\" focus_monitor \"$monitor\" && \"herbstclient\" use \"${i:1}\") ${i:1} ^ca()"
  done
}

add_event() {
  while pgrep --uid $USER herbstluftwm && sleep $3; do A="$1\t$($2)"; test "$A" != "$Z" && Z="$A" && herbstclient emit_hook $A || break; done
}


### Event generator ###
# the goal is to use 'hc emit_hook',with inline dzen2 colors, formed like this:
#   <eventname>\t<data> [...]
# e.g.
#   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29
#
#

while pgrep --uid $USER herbstclient >/dev/null; do
  date="$(getdate)"
  if test "$dateprev" != "$date"; then
    dateprev="$date"
    herbstclient emit_hook $(echo -ne "date\t$date") 2>/dev/null || break
  fi

  battery="$($getbat)"
  if test "$battery" != "$batteryprev"; then
    batteryprev="$battery"
    herbstclient emit_hook $(echo -ne "battery\t$battery") 2>/dev/null || break
    ! $getbat >/dev/null && setflash "$battery" && $getbat status >/dev/null && setflash &
    # first setflash lasts about 28-30 seconds, but flash remains on screen for notification purposes, so
    # the second setflash removes flash if battery is better
  fi

  # Run in case settings are changed via terminal or otherwise
  volume="$($getvol)"
  brightness="$($getbr)"

  sleep 29 # pause end of loop so that it runs through on first run
done & PID+=( $! )


### Output ###
# This part prints dzen data based on the _previous_ data handling run,
# and then waits for the next event to happen.

herbstclient --idle | while true; do
  # Tags
  draw_tags

  # Panel text
#  right=" $separator^fg($textcolor)^ca(button3=$br 1;button4=exec:$br up;button5=exec:$br down) br^fg($fgcolor)$brightness^fg($textcolor)^ca()^ca(button3=$vol mute;button4=exec:$vol up;button5=exec:$vol down) vl^fg($fgcolor)$volume ^ca()$separator $date $separator^fg($textcolor) bat^fg($fgcolor)$battery    "
  right=" $separator^fg($textcolor) br^fg($fgcolor)$brightness^fg($textcolor) vl^fg($fgcolor)$volume $separator $date $separator^fg($textcolor) bat^fg($fgcolor)$battery    "
  right_text_width=$(textwidth "$font" "$(echo \"$right\" | sed 's.\^[^(]*([^)]*)..g')") # get width of right aligned text
  echo -n "$separator$flash ^bg()^fg()${windowtitle//^/^^}" # print left-aligned text
  echo "^pa($(($panel_width - $right_text_width)))$right" # print right-aligned text

  ### Data handling ###
  # This part handles the events generated in the event loop, and sets
  # internal variables based on them. The event and its arguments are
  # read into the array cmd, then action is taken depending on the event
  # name.

  # wait for next event here at 'read'
  IFS=$'\t' read -ra cmd || break
  case "${cmd[0]}" in
    tag*)
    IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"
    ;;
    focus_changed|window_title_changed)
    windowtitle="${cmd[@]:2}"
    ;;
    date)
    date="${cmd[@]:1}"
    ;;
    battery)
    battery="${cmd[@]:1}"
    ;;
    flash)
    flash="${cmd[@]:1}"
    ;;
    volume)
    volume="$($getvol ${cmd[@]:1})"
    ;;
    brightness)
    brightness="$($getbr ${cmd[@]:1})"
    ;;
    togglehidepanel)
    currentmonidx=$(herbstclient list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
    if [ "${cmd[1]}" -ne "$monitor" ] ; then
      continue
    fi
    if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
      continue
    fi
    if $visible; then
      visible='false'
      herbstclient pad $monitor 0
    else
      visible='true'
      herbstclient pad $monitor $panel_height
    fi
    ;;
    reload|quit_panel)
    kill ${PID[@]} & disown
    exit
    ;;
  esac

  ### dzen2 ###
  # After the data is gathered and processed, the output of the previous block
  # gets piped to dzen2.
done | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height -ta l -bg "$bgcolor" -fg "$fgcolor" \
-e "button3=;button4=exec:herbstclient use_index -1;button5=exec:herbstclient use_index +1"
