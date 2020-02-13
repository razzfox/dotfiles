# Termux code to access storage and create Android_data folders on each
# Termux must be running in foreground in order to call these intents (bug?)
echo 'Running termux-setup-storage...'
termux-setup-storage && test -d storage && rm -r storage &

# Note: ln -f follows links instead of replacing them without -n (no-follow)

# hardcoded usbs
# /sdcard -> /storage/self/primary
# /storage/self/primary -> /storage/emulated/0
ln -sfn /storage/emulated/0 $HOME/internal

# known usbs (key follows var rules: start with a letter, no punctuation)
unset usb
declare -A usb=( [uuid57B326F9]='external' )

for drive in /storage/*[^self][^emulated]; do
  externalLocation=${drive}/Android/data/com.termux/files
  driveBasename=${drive##*/}

  # check usb list for uuid with no dash
  knownUSB=${usb[uuid${driveBasename//-}]}

  if test -n "${knownUSB}" -a -d "${externalLocation}"; then
    # create link using known name
    ln -sfn ${externalLocation} $HOME/"${knownUSB}"
  fi

  mkdir -p $HOME/usb
  # create link using uuid before dash
  ln -sfn ${drive} $HOME/usb/${driveBasename%%-*}
done
