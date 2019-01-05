#!/bin/bash
#exec &>panel.out
# Geometry
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") ) # formatted X Y W H
[ -z "$geometry" ] && echo "panel.sh: Invalid monitor $monitor" && exit 1
screen_x=${geometry[0]}
screen_y=${geometry[1]}
screen_w=${geometry[2]}
screen_h=${geometry[3]}
panel_x=$screen_x
panel_width=$screen_w

# change for HiDPI monitors
panel_height=${2:-14}

#herbstclient list_padding -0
#herbstclient pad MONITOR [PADUP [PADRIGHT [PADDOWN [PADLEFT]]]]
if ${3:-true}; then # Top
  panel_y=$screen_y
  monitor_pad="$panel_height 0 0 0"
else # Bottom
  panel_y=$(( ${screen_h} - ${panel_height} ))
  monitor_pad="0 0 $panel_height 0"
fi
herbstclient pad $monitor $monitor_pad


# Theme
#############################
#font='-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*'
#############################
#font='-*-*-*-*-*-*-12-*-*-*-*-*-*-*'
#font='terminus'
font='*'

# Window Title text
fgcolor="$( herbstclient get frame_border_inner_color )"
bgcolor="$( herbstclient get frame_bg_normal_color )"
# Tinted labels on the right side
textcolor="$( herbstclient get window_border_inner_color )"
# Tags
selfg="$bgcolor"
selbg="$( herbstclient get window_border_active_color )"
separator="^bg()^fg($selbg)|"
urgentcolor="$( herbstclient get window_border_urgent_color )"
flashcolor="$urgentcolor"
# Not used
#bordercolor="$(herbstclient get frame_bg_active_color)"


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
      '.') # the tag is empty
      echo -n "^bg()^fg($textcolor)"
      ;;
      ':') # the tag is not empty
      echo -n "^bg()^fg()"
      ;;
      '+') # the tag is viewed on the specified MONITOR, but this monitor is not focused.
      echo -n "^bg(#9CA668)^fg()"
      ;;
      '#') # the tag is viewed on the specified MONITOR and it is focused.
      echo -n "^bg($selbg)^fg()"
      ;;
      '-') # the tag is viewed on a different MONITOR, but this monitor is not focused.
      echo -n "^bg(#9CA668)^fg(#141414)"
      ;;
      '%') # the tag is viewed on a different MONITOR and it is focused.
      echo -n "^bg($selbg)^fg(#141414)"
      ;;
      '!') # the tag contains an urgent window
      echo -n "^bg($urgentcolor)^fg()"
      ;;
      *) # default case should never happen
      echo -n "^bg()^fg($textcolor)"
      ;;
    esac
    # clickable tags if using SVN dzen
    echo -n "^ca(1,\"herbstclient\" focus_monitor \"$monitor\" && \"herbstclient\" use \"${i:1}\") ${i:1} ^ca()"
  done
}

draw_text () {
  echo -n "$separator$flash ^bg()^fg()${windowtitle//^/^^}" # print left-aligned text

#-e "button3=;button4=exec:herbstclient use_index -1;button5=exec:herbstclient use_index +1"
# right=" $separator^fg($textcolor)^ca(button3=$br 1;button4=exec:$br up;button5=exec:$br down) br^fg($fgcolor)$brightness^fg($textcolor)^ca()^ca(button3=$vol mute;button4=exec:$vol up;button5=exec:$vol down) vl^fg($fgcolor)$volume ^ca()$separator $date $separator^fg($textcolor) bat^fg($fgcolor)$battery    "
  right=" $separator^fg($textcolor)"
  right+=" cpu^fg($fgcolor)$cpuload^fg($textcolor)"
  right+=" hd^fg($fgcolor)${diskspace}%"
  right+=" $separator^fg($textcolor)"
  right+=" br^fg($fgcolor)$brightness^fg($textcolor)"
  right+=" vl^fg($fgcolor)$volume"
  right+=" $separator"
#  right+=" ^ca(1,bash $HOME/.config/herbstluftwm/popup_calendar.sh $panel_y $panel_height)${date}^ca()"
  right+=" ^ca(1,herbstclient emit_hook popup_calendar)${date}^ca()"
  right+=" $separator^fg($textcolor)"
  right+=" bat^fg($fgcolor)$battery    "

  right_text_width=$(textwidth "$font" "$(echo \"$right\" | sed 's.\^[^(]*([^)]*)..g')") # get width of right aligned text
  echo "^pa($(($panel_width - $right_text_width)))$right" # print right-aligned text
}

popup_calendar () {
width=180
padding=10
monitor=( $(herbstclient list_monitors |
  grep '\[FOCUS\]$'|cut -d' ' -f2|
  tr x ' '|sed 's/\([-+]\)/ \1/g') )
x=$((${monitor[2]} + ${monitor[0]} - width - padding))

TODAY=$(( $( date +'%d') + 0 ))
MONTH=$( date +'%m' )
YEAR=$( date +'%Y' )

NEXTYEAR=$YEAR
test $MONTH -eq 12 && NEXTYEAR=$(( $YEAR + 1 ))
NEXTMONTH=$( expr \( $MONTH + 1 \) % 12 )

(
echo '^bg(grey70)^fg(#111111)'
# current month, highlight header and today
cal | sed -e "1 s/^\s*//; 3,$ s/\(.*\)/\1                    /; 3,$ s/\(.\{20\}\).*/\1/" \
  | sed -r -e "1,2 s/.*/^fg(white)&^fg()/" \
  -e "s/(^| )($TODAY)($| )/\1^bg(white)^fg(#111)\2^fg()^bg()\3/"
# separator
echo "---------------------"
# next month, highlight header
cal $NEXTMONTH $NEXTYEAR \
  | sed -e "1 s/^\s*//; 1,2 s/.*/^fg(white)&^fg()/; 3,$ s/\(.*\)/\1                    /; 3,$ s/\(.\{20\}\).*/\1/"
) | dzen2 -p 0 -fn 'Monospace-9' -x $x -y $((${panel_y:-20} - ${panel_height:-0})) -w $width -l 17 -sa c -e 'onstart=uncollapse;button1=exit;button3=exit' -bg '#242424'
}

#acpi -b | cut -d' ' -f4
source $HOME/.config/bash/bat.arch
source $HOME/.config/bash/br.arch
# vl commands: up down mute mute_source <num>
source $HOME/.config/bash/vl.arch

# getdate can not be a varibale because of automatic bash smart quoting. FAIL
get_date () {
  # Popup calendar widget
  date=$( date +"^fg($fgcolor)%I:%M^fg($textcolor), %Y-%m-^fg($fgcolor)%d" )
  if test "$date" != "$dateprev"; then
    dateprev="$date"
    herbstclient emit_hook $(echo -ne "date\t$date") 2>/dev/null || break
  fi
}

get_battery () {
  battery="$( bat )"
  if test "$battery" != "$batteryprev"; then
    batteryprev="$battery"
    herbstclient emit_hook $(echo -ne "battery\t$battery") 2>/dev/null || break
    ! bat >/dev/null && setflash "$battery" && bat status >/dev/null && setflash &
    # first setflash lasts about 28-30 seconds, but flash remains on screen for notification purposes, so
    # the second setflash removes flash if battery is better
  fi
}

get_volume () {
  # Run in case settings are changed via terminal or otherwise
  volume="$( vl )"
  if test "$volume" != "$volumeprev"; then
    volumeprev="$volume"
    herbstclient emit_hook $(echo -ne "volume\t$volume") 2>/dev/null || break
  fi
}

get_brightness () {
  brightness="$( br )"
  if test "$brightness" != "$brightnessprev"; then
    brightnessprev="$brightness"
    herbstclient emit_hook $(echo -ne "brightness\t$brightness") 2>/dev/null || break
  fi
}

get_diskspace () {
  diskspace="$( df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1 )"
  if test "$diskspace" != "$diskspaceprev"; then
    diskspaceprev="$diskspace"
    herbstclient emit_hook $(echo -ne "diskspace\t$diskspace") 2>/dev/null || break
  fi
}

get_cpuload2 () {
  # cores=$( grep -c ^processor /proc/cpuinfo )
  # Gives cores + 1
  cpu=$( grep -c ^cpu /proc/stat )
  A=($(sed -n '2,5p' /proc/stat))
  # sleep 0.2
  sleep ${1:-5}
  C=($(sed -n '2,5p' /proc/stat))
  # user         + nice     + system   + idle
  B0=$((${A[1]}  + ${A[2]}  + ${A[3]}  + ${A[4]}))
  B1=$((${A[12]} + ${A[13]} + ${A[14]} + ${A[15]}))
  # B2=$((${A[23]} + ${A[24]} + ${A[25]} + ${A[26]}))
  # B3=$((${A[34]} + ${A[35]} + ${A[36]} + ${A[37]}))
  # user         + nice     + system   + idle
  D0=$((${C[1]}  + ${C[2]}  + ${C[3]}  + ${C[4]}))
  D1=$((${C[12]} + ${C[13]} + ${C[14]} + ${C[15]}))
  # D2=$((${C[23]} + ${C[24]} + ${C[25]} + ${C[26]}))
  # D3=$((${C[34]} + ${C[35]} + ${C[36]} + ${C[37]}))
  # cpu usage per core
  E0=$((100 * (B0 - D0 - ${A[4]}  + ${C[4]})  / (B0 - D0)))
  E1=$((100 * (B1 - D1 - ${A[15]} + ${C[15]}) / (B1 - D1)))
  # E2=$((100 * (B2 - D2 - ${A[26]} + ${C[26]}) / (B2 - D2)))
  # E3=$((100 * (B3 - D3 - ${A[37]} + ${C[37]}) / (B3 - D3)))

  # cpuload=( $( bash $HOME/code/bashcpu.sh ) )
  cpuload="$E0 $E1"
  herbstclient emit_hook $(echo -ne "cpuload\t${cpuload[@]}") 2>/dev/null || break
}

get_cpuload4 () {
  # Gives cores + 1
  cpu=$( grep -c ^cpu /proc/stat )
  A=($(sed -n '2,5p' /proc/stat))
  # sleep 0.2
  sleep ${1:-5}
  C=($(sed -n '2,5p' /proc/stat))
  # user         + nice     + system   + idle
  B0=$((${A[1]}  + ${A[2]}  + ${A[3]}  + ${A[4]}))
  B1=$((${A[12]} + ${A[13]} + ${A[14]} + ${A[15]}))
  B2=$((${A[23]} + ${A[24]} + ${A[25]} + ${A[26]}))
  B3=$((${A[34]} + ${A[35]} + ${A[36]} + ${A[37]}))
  # user         + nice     + system   + idle
  D0=$((${C[1]}  + ${C[2]}  + ${C[3]}  + ${C[4]}))
  D1=$((${C[12]} + ${C[13]} + ${C[14]} + ${C[15]}))
  D2=$((${C[23]} + ${C[24]} + ${C[25]} + ${C[26]}))
  D3=$((${C[34]} + ${C[35]} + ${C[36]} + ${C[37]}))
  # cpu usage per core
  E0=$((100 * (B0 - D0 - ${A[4]}  + ${C[4]})  / (B0 - D0)))
  E1=$((100 * (B1 - D1 - ${A[15]} + ${C[15]}) / (B1 - D1)))
  E2=$((100 * (B2 - D2 - ${A[26]} + ${C[26]}) / (B2 - D2)))
  E3=$((100 * (B3 - D3 - ${A[37]} + ${C[37]}) / (B3 - D3)))

  # cpuload=( $( bash $HOME/code/bashcpu.sh ) )
  cpuload="$E0 $E1 $E2 $E3"
  herbstclient emit_hook $(echo -ne "cpuload\t${cpuload[@]}") 2>/dev/null || break
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


# Initialize Variables
date="$( date +"^fg($fgcolor)%I:%M^fg($textcolor), %Y-%m-^fg($fgcolor)%d" )"
dateprev="$date"
popup_calendarprev=
battery="$( bat )"
batteryprev="$battery"
volume="$( vl )"
volumeprev="$volume"
brightness="$( br )"
brightnessprev="$brightness"
cores="$( grep -c ^processor /proc/cpuinfo )"
cpuload="---"
diskspace="$( df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1 )"
diskspaceprev="$diskspace"

windowtitle="$(herbstclient stack | grep -F -A1 Focus-Layer | tail -n 1 | cut -d '"' -f 2 | grep -F -v Fullscreen-Layer)"
IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status $monitor)"


### Event generator ###
# the goal is to use 'hc emit_hook',with inline dzen2 colors, formed like this:
#   <eventname>\t<data> [...]
# e.g.
#   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

# add_event () {
#   while pgrep --uid $USER herbstluftwm &>/dev/null && sleep $3; do A="$1\t$($2)"; test "$A" != "$Z" && Z="$A" && herbstclient emit_hook $A || break; done
# }

while true; do
  get_date

  # Inspiration from this address:
  # https://github.com/dustinkirkland/byobu/blob/master/usr/bin/wifi-status
  #get_ipaddress

  get_battery

  get_volume

  get_brightness

  get_diskspace

  for i in 1 2 3 4 5 6 7 8; do
    # get_fanspeed
    # get_cputemp
    # get_cpuspeed

    # get_cpuload sleeps internally, so it can be used to sleep the main loop
    # 3.625 sec x 8 = 29 sec
    get_cpuload$cores 3.625
  done
# output to null so it doesn't print the entire block when terminated
done &>/dev/null &
PID="$! $PID"


# Signal handler declared after child processes so that it only applies to the last bash
sighandler () {
  kill $PID $@
  exit
}
trap sighandler SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM


### Data handler ###
# This part handles the hooks emitted in the event loop(s) above and by
# hlwm itself (focus and tags), then sets variables based on them.

# The event and its arguments are read into the array 'cmd', then
# action is taken depending on the name (first array item).
herbstclient --idle | while true; do
  ### Output ###
  # This part prints dzen data based on the initial and previous data handling

  # Tags on left side
  draw_tags
  # Text in the middle and right side
  draw_text

  # The loop waits here at 'read' for the next event hook for 29 seconds
  IFS=$'\t' read -ra cmd
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

      # this check for focus changed fixes when focus changes is usually followed by window title cange, but sometimes focus changed does not happen when a window closes
      if ! $focus_changed || test -z "$windowtitle"; then
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
    floating)
      true
      ;;
    pseudotile)
      true
      ;;
    date)
      date="${cmd[@]:1}"
      ;;
    popup_calendar)
      popup_calendar &
      ;;
    battery)
      battery="${cmd[@]:1}"
      ;;
    flash)
      flash="${cmd[@]:1}"
      ;;
    volume)
      volume="$(vl ${cmd[@]:1})"
      ;;
    brightness)
      brightness="$(br ${cmd[@]:1})"
      ;;
    cpuload)
      cpuload="${cmd[@]:1}"
      ;;
    diskspace)
      diskspace="${cmd[@]:2}"
      ;;
    # togglehidepanel)
    #   currentmonidx=$(herbstclient list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
    #   if [ "${cmd[1]}" -ne "$monitor" ] ; then
    #     continue
    #   fi
    #   if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
    #     continue
    #   fi
    #   if ${visible:-false}; then
    #     visible='false'
    #     herbstclient pad $monitor 0
    #   else
    #     visible='true'
    #     herbstclient pad $monitor $panel_height
    #   fi
    #   ;;
    quit_panel)
      herbstclient pad $monitor 0 0 0 0
      break
      ;;
    reload)
      break
      ;;
  esac &>/dev/null
  # No output should get to dzen2, only variable updates


  ### dzen2 ###
  # After the data is gathered and processed, the output gets piped to dzen2.
done | dzen2 -w $panel_width -x $panel_x -y $panel_y -fn "$font" -h $panel_height -ta l -bg "$bgcolor" -fg "$fgcolor"

sighandler
