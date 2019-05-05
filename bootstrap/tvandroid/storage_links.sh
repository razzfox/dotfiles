# Termux code to access storage and create Android_data folders on each
# Termux must be running in foreground in order to call these intents (bug?)
echo 'Running termux-setup-storage...'
termux-setup-storage && test -d storage && rm -r storage &

# Note: ln -f follows links instead of replacing them without -n (no-follow)

# hardcoded usbs
#ln -sfn /storage/7BB3-1816/Android/data/com.termux external
# /sdcard -> /storage/self/primary -> /storage/emulated/0
ln -sfn /storage/emulated/0 internal

# known usbs (key follows var rules: start with a letter, no punctuation)
#[uuidsdcard]='internal'
unset usb
declare -A usb=( [uuid7BB31816]='external' [uuid033E1DE8]='bluestick' )

for drive in /storage/[0-9]*; do
  # basename
  driveName=${drive##*/}
  # check known name, no dash
  knownUSB=${usb[uuid${driveName//-}]}
  if test -n "${knownUSB}"; then
    # create link using known name
    ln -sfn ${drive}/Android/data/com.termux/files $HOME/${knownUSB}
  else
    mkdir -p $HOME/usb
    # create link using uuid before dash
    ln -sfn ${drive}/Android/data/com.termux/files $HOME/usb/${driveName%%-*}
  fi
done
