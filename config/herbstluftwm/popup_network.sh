INTERFACE=wlp3s0
SLEEP=1

# Here we remember the previous rx/tx counts
RXB=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
TXB=`cat /sys/class/net/${INTERFACE}/statistics/tx_bytes`

while :; do

    # get new rx/tx counts
    RXBN=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
    TXBN=`cat /sys/class/net/${INTERFACE}/statistics/tx_bytes`

    # calculate the rates
    # format the values to 4 digit fields
    RXR=$(printf "%4d\n" $(echo "($RXBN - $RXB) / 1024/${SLEEP}" | bc))
    TXR=$(printf "%4d\n" $(echo "($TXBN - $TXB) / 1024/${SLEEP}" | bc))

    # print out the rates with some nice formatting
    echo "${INTERFACE}: ^fg(white)${RXR}kB/s^fg(#80AA83)^p(3)^i(${ICONPATH}/arr_down.xbm)^fg(white)${TXR}  kB/s^fg(orange3)^i(${ICONPATH}/arr_up.xbm)^fg()"

    # reset old rates
    RXB=$RXBN; TXB=$TXBN

    sleep $SLEEP
done | dzen2
