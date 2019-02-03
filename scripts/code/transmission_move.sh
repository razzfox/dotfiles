#!/usr/bin/env bash
# Transmission script to move files to post-processing
# and/or specified directories.
# AUTHOR: divreg <https://github.com/divreg>

#################################################################################
# These are inherited from Transmission.                                        #
# Do not declare these. Just use as needed.                                     #
#                                                                               #
# TR_APP_VERSION                                                                #
# TR_TIME_LOCALTIME                                                             #
# TR_TORRENT_DIR                                                                #
# TR_TORRENT_HASH                                                               #
# TR_TORRENT_ID                                                                 #
# TR_TORRENT_NAME                                                               #
#                                                                               #
#################################################################################


#################################################################################
#                                    CONSTANTS                                  #
#                         configure directories and filetypes                   #
#################################################################################


# Use recursive hardlinks (cp -al) only if both Transmission's seed dir and 
# the final dir belong to the same filesystem.  Set to false to make a 
# duplicate copy. Note: true allows you to seed and copy without using up 
# twice the storage.
HARDLINKS=true

# The file for logging events from this script
LOGFILE="/var/lib/transmission/.config/transmission-daemon/transmission-complete.log"

# Listening directories
MUSIC_DIR="/storage/music/flac"

# Transmission remote login details. Leave user:pass blank if no authentication
TR_HOST="0.0.0.0"

# Music extensions
FIND_EXTS=( mp4 mkv )

# Path to new content from transmission
TR_DOWNLOADS="$TR_TORRENT_DIR/$TR_TORRENT_NAME"


#################################################################################
#                                 SCRIPT CONTROL                                #
#                               edit with caution                               #
#################################################################################


function edate 
{
  echo "`date '+%Y-%m-%d %H:%M:%S'`    $1" >> "$LOGFILE"
}

function trans_check
{
  for directory in $(find "$TR_DOWNLOADS" -type d)
  do
    cd "$TR_DOWNLOADS" > /dev/null 2>&1
    cd $directory > /dev/null 2>&1
    files=$(ls *.${MUSIC_EXTS[*]} 2> /dev/null | wc -l)
    if [ $files != "0" ] 
    then
      echo "$files"
      continue
    fi
  done
}

edate "Directory is $TR_TORRENT_DIR"
edate "Torrent ID is $TR_TORRENT_ID"
edate "Torrent Hash is $TR_TORRENT_HASH"
edate "Working on the new download $TR_DOWNLOADS"


# Move new music dir and files to the listening location
# Passes through if none of your extension types are found in
# the new music dir
if [ "$(trans_check ${MUSIC_EXTS[*]})" ]
then
  edate "File $TR_TORRENT_NAME contains audio files!"
  if [ $HARDLINKS == true ] 
  then 
    edate "Hardlinking file contents to listening directory. Success!"
    cp -al "$TR_DOWNLOADS" "$MUSIC_DIR" >> "$LOGFILE"
  fi
  if [ $HARDLINKS == false ]
  then 
    edate "Duplicating file contents to listening directory. Success!"
    cp -R "$TR_DOWNLOADS" "$MUSIC_DIR" >> "$LOGFILE" 
  fi
fi
