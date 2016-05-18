#!/bin/bash

# Geometry
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") ) # formatted W H X Y
[ -z "$geometry" ] && echo "Invalid monitor $monitor" && exit 1
x=${geometry[0]}
y=${geometry[1]}
#panel_width=$(( ${geometry[2]} -25 ))
panel_width=${geometry[2]}

# change for HiDPI monitors
panel_height=${2:-15}
herbstclient pad $monitor $panel_height

# Theme
font='-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*'
# Window Title text
fgcolor="$(herbstclient get frame_border_inner_color)"
bgcolor="$(herbstclient get frame_bg_normal_color)"
# Tinted labels on the right side
textcolor="$(herbstclient get window_border_inner_color)"
# Tags
selfg="$bgcolor"
selbg="$(herbstclient get window_border_active_color)"
separator="^bg()^fg($selbg)|"
urgentcolor="$(herbstclient get window_border_urgent_color)"
flashcolor="$urgentcolor"
# Not used
#bordercolor="$(herbstclient get frame_bg_active_color)"

# Variables
#acpi -b | cut -d' ' -f4
getbat="bash $HOME/.config/shell/bat.arch"
# Possible commands: up down mute mute_source <num>
getvol="bash $HOME/.config/shell/vl.arch"
getbr="bash $HOME/.config/shell/br.arch"

# Initialize vars
battery='00.0%'
volume="$($getvol)"
brightness="$($getbr)"
visible='true'
windowtitle="$(herbstclient stack | grep -F -A1 Focus-Layer | tail -n 1 | cut -d '"' -f 2 | grep -F -v Fullscreen-Layer)"
IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"

# Functions
getdate () {
  # have so many problems with this, so I made a function
  date +"^fg($fgcolor)%I:%M^fg($textcolor), %Y-%m-^fg($fgcolor)%d"
}

setflash () {
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

tag () {
case "$1" in
# create)
#   #NEWTAG="$( echo | dmenu -p 'New tag name:' )"
#   INDEX=$( herbstclient get_attr tags.count )
#   INDEX=$(( $INDEX + 1 ))
#   herbstclient substitute INDEX tags.focus.index chain : add $INDEX : use $INDEX : emit_hook rename_index INDEX
#   ;;
# break_out)
#   #herbstclient substitute NAME clients.focus.class chain : rename NAME default : add NAME : move NAME : use NAME
#   herbstclient substitute INDEX tags.count chain : add INDEX : move INDEX : use INDEX
#   ;;
# delete)
#   DELTAG="$( printf '%s\n' $(herbstclient tag_status | tr -d [:punct:] ) | dmenu -p 'Delete tag:' )"
#   if test "$DELTAG" = "$( herbstclient get_attr tags.focus.name )"; then
#     if test $( herbstclient get_attr tags.focus.index ) != 0; then
#       herbstclient use_index -1
#     else
#       herbstclient use_index +1
#     fi
#   fi
#   herbstclient merge_tag "$DELTAG"
#   ;;
# move_previous)
#   herbstclient substitute ID clients.focus.winid chain : use_previous : bring ID : use_previous
#   ;;
# rename_next)
#   tag rename_index $(( $2 + 1 ))
#   ;;
# rename_prev)
#   tag rename_index $(( $2 - 1 ))
#   ;;
rename_index)
  unset NAME
  if test -n "$2"; then
    # takes a number index starting from zero, and optionally +1 or -1 plus count
    INDEX="$2"

    # takes a third and fourth argument to rename an arbitrary index from a starting index
    # does not check for numbers larger than the total number of tags
    if test -n "$4"; then
      INDEX=$(( $INDEX $3 ))
      if test "$INDEX" -lt "0"; then
        # wrap around, positive number by starting with the total number of tags
        INDEX=$(( $4 $3 ))
      elif test "$INDEX" -gt "$(( $4 - 1 ))"; then
        # wrap around, positive number by subtracting the total number of tags
        INDEX=$(( $INDEX - $4 ))
      fi
    fi
    TAG="$( herbstclient get_attr tags.${INDEX}.name )"
    for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
      if herbstclient compare clients.${i}tag = "${TAG}"; then
        # Use clients.focus.instance or class
        NAME="$( herbstclient get_attr clients.${i}class )"
        break
      fi
    done
  else
    INDEX=$( herbstclient get_attr tags.focus.index )
    TAG="$( herbstclient get_attr tags.focus.name )"
    NAME="$( herbstclient get_attr clients.focus.class )"
  fi

  INDEX=$(( $INDEX + 1 ))
  test -n "$NAME" && NAME=" $NAME" || INDEX=" $INDEX "
  herbstclient rename "$TAG" "${INDEX}${NAME}"
  ;;
update)
  # Must update all because the order of tags may change after one is deleted
  COUNT=$( herbstclient get_attr tags.count )
  for i in $( seq 0 $(( $COUNT - 1 )) ); do
    tag rename_index $i
  done

  # This only updates tags with windows
  # unset TAGS
  # for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
  #   #TAG=$( herbstclient get_attr clients.${i}tag )
  #   INDEX=$( herbstclient get_attr tags.by-name.${TAG}.index )
  #   #TAGS="$( echo $TAGS $INDEX | tr '[:space:]' '\n' | sort | uniq )"
  #   TAGS="TAGS $INDEX"
  # done
  # for i in $( echo $TAGS $INDEX | tr '[:space:]' '\n' | sort | uniq ); do
  #   tag rename_index $i
  # done

  # don't quote this because bash elects to smart quote it for us
  tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
  tag_keys=( $( seq ${#tag_names[@]} ) )
  unset COMMANDS
  for i in ${!tag_names[@]} ; do
      key="${tag_keys[$i]}"
      if ! [ -z "$key" ] ; then
          COMMANDS="$COMMANDS , keybind Super-$key use_index $i , keybind Super-Shift-$key chain : move_index $i : emit_hook rename_index $i"
      fi
  done
  herbstclient chain $COMMANDS
  ;;
esac
}

# TODO: Pad spacing by the longest possible name (ALL WINDOWS) so they are generally the same width
draw_tags () {
  for i in "${tags[@]}"; do
    case ${i:0:1} in
      '#')
      echo -n "^bg($selbg)^fg($selfg)"
      ;;
      '+')
      echo -n "^bg(#9CA668)^fg(#141414)"
      ;;
      ':')
      echo -n "^bg()^fg()"
      ;;
      '!')
      echo -n "^bg($urgentcolor)^fg(#141414)"
      ;;
      *)
      echo -n "^bg()^fg($textcolor)"
      ;;
    esac
    # clickable tags if using SVN dzen
    echo -n "^ca(1,\"herbstclient\" focus_monitor \"$monitor\" && \"herbstclient\" use \"${i:1}\") ${i:1} ^ca()"
  done
}

draw_text () {
  # right=" $separator^fg($textcolor)^ca(button3=$br 1;button4=exec:$br up;button5=exec:$br down) br^fg($fgcolor)$brightness^fg($textcolor)^ca()^ca(button3=$vol mute;button4=exec:$vol up;button5=exec:$vol down) vl^fg($fgcolor)$volume ^ca()$separator $date $separator^fg($textcolor) bat^fg($fgcolor)$battery    "
  right=" $separator^fg($textcolor) br^fg($fgcolor)$brightness^fg($textcolor) vl^fg($fgcolor)$volume $separator $date $separator^fg($textcolor) bat^fg($fgcolor)$battery    "
  right_text_width=$(textwidth "$font" "$(echo \"$right\" | sed 's.\^[^(]*([^)]*)..g')") # get width of right aligned text
  echo -n "$separator$flash ^bg()^fg()${windowtitle//^/^^}" # print left-aligned text
  echo "^pa($(($panel_width - $right_text_width)))$right" # print right-aligned text
}


### Event generator ###
# the goal is to use 'hc emit_hook',with inline dzen2 colors, formed like this:
#   <eventname>\t<data> [...]
# e.g.
#   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

# add_event () {
#   while pgrep --uid $USER herbstluftwm &>/dev/null && sleep $3; do A="$1\t$($2)"; test "$A" != "$Z" && Z="$A" && herbstclient emit_hook $A || break; done
# }

while true; do
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
done &>/dev/null & PID=$!
# output to null so it doesn't print the entire block when terminated


sighandler () {
  kill ${PID}
  echo "Exiting panel.sh"
  exit
}

trap sighandler SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM


### Data handling loop ###
# This part handles the hooks emitted in the event loop(s) above and by
# hlwm itself (focus and tags), then sets variables based on them.

# The event and its arguments are read into the array 'cmd', then
# action is taken depending on the name (first array item).
# The loop waits here at 'read' for the next event hook.
herbstclient --idle | while IFS=$'\t' read -ra cmd || break; do
  case "${cmd[0]}" in
    tag_added|tag_removed)
      # Sets new keybinds
      tag update &
      ;;
    rename_index)
      # call rename_index by name because of fall-through case
      tag rename_index ${cmd[@]:1} &
      ;;
    tag_renamed)
      IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"
      ;;
    window_title_changed)
      windowtitle="${cmd[@]:2}"

      if ! $focus_changed; then
        tag rename_index &
        IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"
      fi
      focus_changed=false
      ;;
    tag_changed)
      if ! $focus_changed; then
        tag rename_index &
      fi
      IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"
      focus_changed=false
      ;;
    focus_changed)
      # focus_changed is not called when the focus changes from an empty pane to another empty pane, including between empty tags
      tag rename_index &
      windowtitle="${cmd[@]:2}"
      focus_changed=true
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
      kill ${PID}
      break
      ;;
  esac

  ### Output ###
  # This part prints dzen data based on the _previous_ data handling run,
  # and then waits for the next event to happen.

  # Tags on left side
  draw_tags
  # Text in the middle and right side
  draw_text

  ### dzen2 ###
  # After the data is gathered and processed, the output gets piped to dzen2.
done | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height -ta l -bg "$bgcolor" -fg "$fgcolor" \
-e "button3=;button4=exec:herbstclient use_index -1;button5=exec:herbstclient use_index +1"

sighandler
