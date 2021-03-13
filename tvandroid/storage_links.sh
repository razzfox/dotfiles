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
declare -A usb=(
  [uuid5CC0010E]='external'
  [external]='uuid5CC0010E'
  # [uuid67E317ED]='external_efi'
)

echo ${usb[@]}

# safely delete all links
rm usb/*

for drive in /storage/*[^self][^emulated]; do
  driveBasename=${drive##*/}

  # check usb list for uuid with no dash
  knownUSB=${usb[uuid${driveBasename//-}]}
  externalLocation=${drive}/Android/data/com.termux/files
  # drive must have an Android app files location
  if test -n "${knownUSB}" -a -d "${externalLocation}"; then
    # create link using known name
    ln -vsfn ${externalLocation} $HOME/"${knownUSB}"
  else
    echo known: $knownUSB
    echo appFiles: $externalLocation
  fi

  mkdir -p $HOME/usb
  # create link using uuid before dash
  ln -vsfn ${drive} $HOME/usb/${driveBasename%%-*}
done
