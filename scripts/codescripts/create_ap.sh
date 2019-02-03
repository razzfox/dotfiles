source $HOME/scripts/bridgesetup.sh

if create_ap --list-running | grep ap0; then
  create_ap --list-clients ap0
  exit 1
fi

sudo create_ap \
-m nat wlp3s0 br0 \
cuddles tastegood

#  --hidden \
#  --daemon \
#  --freq-band 5 --ieee80211ac \

#trap SIG_HUP cleanup
#function cleanup {
#  sudo create_ap --stop ap0
#}
