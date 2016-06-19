# View screenshots at http://alexandre.deverteuil.net/consolefonts/consolefonts.html
# Write FONT= to /etc/vconsole.conf for systemd at boot

test $EUID != 0 && echo "Error: You must be root to do this." >/dev/stderr && return 1

PREVFONT="tail -c +6 <(egrep ^FONT= /etc/vconsole.conf)"

# See installed fonts
cd /usr/share/kbd/consolefonts/

for FONT in $(/bin/ls); do
  if [[ ! -d $FONT ]]; then
    # test font or revert to default
    setfont $FONT
    clear
    ls
    # Show entire character set
    showconsolefont

    echo
    echo $FONT
    echo
    fortune
    echo
    echo "Press Return to go to next font, d to move to donotwant, s to save, o to open vconsole.conf, or q to quit with previous font"
    read TASK

    # TODO: make this into a switch case and catch ctrl-C
    if [[ $TASK == 'd' ]]; then
      mkdir --parents donotwant
      mv $FONT donotwant/
    fi

    if [[ $TASK == 's' ]]; then
      egrep -v ^FONT= /etc/vconsole.conf > /etc/vconsole.conf.new
      echo FONT=$FONT >> /etc/vconsole.conf.new
      mv /etc/vconsole.conf.new /etc/vconsole.conf
      return 0
    fi

    if [[ $TASK == 'o' ]]; then
      exec nano /etc/vconsole.conf
    fi

    if [[ $TASK == 'q' ]]; then
      setfont $PREVFONT
      return 0
    fi

  fi
done
