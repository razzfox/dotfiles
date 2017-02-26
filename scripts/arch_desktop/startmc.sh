mcgrep() {
  test -f $HOME/.minecraft/mcitems || curl 'http://minecraft-ids.grahamedgecombe.com/' | sed 's/\[.*\]//g' >$HOME/.minecraft/mcitems

  for i in "$@"; do
    grep --fixed-strings --silent --ignore-case $HOME/.minecraft/mcitems -e $i
  done
}

startmc() {
  if [[ $1 == -h ]] || [[ $1 == --help ]]; then
    echo "Usage: startmc [client] [(server) -u -d -g] [backup [dir]]"

  elif [[ $1 == "backup" ]]; then

    if [[ $# == 2 ]]; then

      if [[ -d $2 ]]; then
        echo "rsync -r $HOME/.minecraft into $2/mcbackup/minecraft/"
        mkdir --parents "$2"/mcbackup/
        rsync -r $HOME/.minecraft/ "$2"/mcbackup/minecraft/
      else
        echo "Warning: '$2' does not exist" >/dev/stderr
      fi

    else
      echo "rsync -r $HOME/.minecraft into $HOME/mcbackup/minecraft/"
      mkdir --parents $HOME/mcbackup/
      rsync -r $HOME/.minecraft/ $HOME/mcbackup/minecraft/
    fi

  elif [[ -d $HOME/.minecraft/server/ ]] || [[ $1 == "server" ]]; then

    if [[ -f server.properties ]] || [[ $1 == "-g" ]] || [[ $2 == "-g" ]] || [[ $3 == "-g" ]]; then

      screen -ls | grep --fixed-strings --silent "$(basename $PWD)"
      if [[ $? == 0 ]]; then
        screen -ls
        echo "Use 'screen -r $(basename $PWD)' to connect and ^A^D to disconnect (^=control key)."

      else

        mcgrep &>/dev/null
        echo "Notice: Use 'mcgrep <item>' to search for Minecraft item codes" >/dev/stderr

        if [[ $1 == "-g" ]] || [[ $2 == "-g" ]] || [[ $3 == "-g" ]]; then
          echo "It is recommended to edit the server.properties"
        fi

        echo "Starting server $(basename $PWD | tr -d [:space:] | tr [:upper:] [:lower:])"

        if [[ $1 == "-d" ]] || [[ $2 == "-d" ]] || [[ $3 == "-d" ]]; then
          screen -Sdm $(basename $PWD | tr -d [:space:] | tr [:upper:] [:lower:]) java -Xmx3G -Xms3G -jar $HOME/.minecraft/server/minecraft_server*.jar nogui
          screen -ls
        else
          java -Xmx3G -jar $HOME/.minecraft/server/minecraft_server*.jar nogui
        fi
      fi

      elif [[ $1 == "-u" ]] || [[ $2 == "-u" ]] || [[ $3 == "-u" ]]; then
          VERSION='1.7.9'

          echo "Updating server jar at $HOME/.minecraft/server/minecraft_server*.jar"
          mkdir --parents $HOME/.minecraft/server/old/

          PREVIOUS="$PWD"
          cd $HOME/.minecraft/server/

          mv minecraft_server* ./old/
          wget https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/minecraft_server.$VERSION.jar

          cd "$PREVIOUS"

    else
      echo "Server status:"
      screen -ls | grep --fixed-strings --silent "No Sockets found"
      if [[ $? == 0 ]]; then
        echo "No server.properties found in ${PWD}."
      else
        screen -ls
        echo "Use 'screen -r $(screen -ls | head -c 33 | tail -c 3)...' to connect and ^A^D to disconnect (^=control key)."
      fi

      echo " --> Use 'startmc [server] -g' to generate a new world in this directory,"
      echo " --> otherwise copy $HOME/.minecraft/server.properties here and edit it."
    fi

  elif [[ $# == 0 ]] || [[ $1 == "client" ]]; then

    echo "Notice: Use 'mcgrep item' to search for Minecraft item codes"
    if [[ ! -f $HOME/.minecraft/mcitems ]]; then
      echo "Downloading Minecraft ID List to $HOME/.minecraft/mcitems"
      curl 'http://minecraft-ids.grahamedgecombe.com/' | sed 's/\[.*\]//g'> $HOME/.minecraft/mcitems
    fi

    if [[ -f $HOME/.minecraft/Minecraft.jar ]]; then

        echo "Starting Minecraft client"

        if [[ $1 == "-d" ]] || [[ $2 == "-d" ]] || [[ $3 == "-d" ]]; then
          java -jar $HOME/.minecraft/Minecraft.jar &>/dev/null &

        else
          java -jar $HOME/.minecraft/Minecraft.jar
        fi

    else
      echo "Warning: $HOME/.minecraft/Minecraft.jar not found. Downloading Minecraft.jar" >/dev/stderr
      mkdir --parents $HOME/.minecraft/

      PREVIOUS="$PWD"
      cd $HOME/.minecraft/

      wget https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar

      cd "$PREVIOUS"

      startmc
    fi

  fi
}


startmc "$@"
