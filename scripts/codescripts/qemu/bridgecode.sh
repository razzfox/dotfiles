# Set up bridge. Code copied from create_ap.

is_bridge_interface() {
    [[ -z "$1" ]] && return 1
    [[ -d "/sys/class/net/${1}/bridge" ]]
}

NETWORKMANAGER_CONF=/etc/NetworkManager/NetworkManager.conf
NM_OLDER_VERSION=1

networkmanager_exists() {
    local NM_VER
    which nmcli > /dev/null 2>&1 || return 1
    NM_VER=$(nmcli -v | grep -m1 -oE '[0-9]+(\.[0-9]+)*\.[0-9]+')
    version_cmp $NM_VER 0.9.9
    if [[ $? -eq 1 ]]; then
        NM_OLDER_VERSION=1
    else
        NM_OLDER_VERSION=0
    fi
    return 0
}

networkmanager_is_running() {
    local NMCLI_OUT
    networkmanager_exists || return 1
    if [[ $NM_OLDER_VERSION -eq 1 ]]; then
        NMCLI_OUT=$(nmcli -t -f RUNNING nm 2>&1 | grep -E '^running$')
    else
        NMCLI_OUT=$(nmcli -t -f RUNNING g 2>&1 | grep -E '^running$')
    fi
    [[ -n "$NMCLI_OUT" ]]
}

networkmanager_iface_is_unmanaged() {
    is_interface "$1" || return 2
    (nmcli -t -f DEVICE,STATE d 2>&1 | grep -E "^$1:unmanaged$" > /dev/null 2>&1) || return 1
}

ADDED_UNMANAGED=

networkmanager_add_unmanaged() {
    local MAC UNMANAGED WAS_EMPTY x
    networkmanager_exists || return 1

    [[ -d ${NETWORKMANAGER_CONF%/*} ]] || mkdir -p ${NETWORKMANAGER_CONF%/*}
    [[ -f ${NETWORKMANAGER_CONF} ]] || touch ${NETWORKMANAGER_CONF}

    if [[ $NM_OLDER_VERSION -eq 1 ]]; then
        if [[ -z "$2" ]]; then
            MAC=$(get_macaddr "$1")
        else
            MAC="$2"
        fi
        [[ -z "$MAC" ]] && return 1
    fi

    mutex_lock
    UNMANAGED=$(grep -m1 -Eo '^unmanaged-devices=[[:alnum:]:;,-]*' /etc/NetworkManager/NetworkManager.conf)

    WAS_EMPTY=0
    [[ -z "$UNMANAGED" ]] && WAS_EMPTY=1
    UNMANAGED=$(echo "$UNMANAGED" | sed 's/unmanaged-devices=//' | tr ';,' ' ')

    # if it exists, do nothing
    for x in $UNMANAGED; do
        if [[ $x == "mac:${MAC}" ]] ||
               [[ $NM_OLDER_VERSION -eq 0 && $x == "interface-name:${1}" ]]; then
            mutex_unlock
            return 2
        fi
    done

    if [[ $NM_OLDER_VERSION -eq 1 ]]; then
        UNMANAGED="${UNMANAGED} mac:${MAC}"
    else
        UNMANAGED="${UNMANAGED} interface-name:${1}"
    fi

    UNMANAGED=$(echo $UNMANAGED | sed -e 's/^ //')
    UNMANAGED="${UNMANAGED// /;}"
    UNMANAGED="unmanaged-devices=${UNMANAGED}"

    if ! grep -E '^\[keyfile\]' ${NETWORKMANAGER_CONF} > /dev/null 2>&1; then
        echo -e "\n\n[keyfile]\n${UNMANAGED}" >> ${NETWORKMANAGER_CONF}
    elif [[ $WAS_EMPTY -eq 1 ]]; then
        sed -e "s/^\(\[keyfile\].*\)$/\1\n${UNMANAGED}/" -i ${NETWORKMANAGER_CONF}
    else
        sed -e "s/^unmanaged-devices=.*/${UNMANAGED}/" -i ${NETWORKMANAGER_CONF}
    fi

    ADDED_UNMANAGED="${ADDED_UNMANAGED} ${1} "
    mutex_unlock

    local nm_pid=$(pidof NetworkManager)
    [[ -n "$nm_pid" ]] && kill -HUP $nm_pid

    return 0
}

networkmanager_wait_until_unmanaged() {
    local RES
    networkmanager_is_running || return 1
    while :; do
        networkmanager_iface_is_unmanaged "$1"
        RES=$?
        [[ $RES -eq 0 ]] && break
        [[ $RES -eq 2 ]] && die "Interface '${1}' does not exist.
       It's probably renamed by a udev rule."
        sleep 1
    done
    sleep 2
    return 0
}


INTERNET_IFACE=enp3s0

# disable iptables rules for bridged interfaces
        if [[ -e /proc/sys/net/bridge/bridge-nf-call-iptables ]]; then
            echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables
        fi

        # to initialize the bridge interface correctly we need to do the following:
        #
        # 1) save the IPs and route table of INTERNET_IFACE
        # 2) if NetworkManager is running set INTERNET_IFACE as unmanaged
        # 3) create BRIDGE_IFACE and attach INTERNET_IFACE to it
        # 4) set the previously saved IPs and route table to BRIDGE_IFACE
        #
        # we need the above because BRIDGE_IFACE is the master interface from now on
        # and it must know where is connected, otherwise connection is lost.
        if ! is_bridge_interface $INTERNET_IFACE; then
            echo -n "Create a bridge interface... "
            OLD_IFS="$IFS"
            IFS=$'\n'

            IP_ADDRS=( $(ip addr show $INTERNET_IFACE | grep -A 1 -E 'inet[[:blank:]]' | paste - -) )
            ROUTE_ADDRS=( $(ip route show dev $INTERNET_IFACE) )

            IFS="$OLD_IFS"

            if networkmanager_is_running; then
                networkmanager_add_unmanaged $INTERNET_IFACE
                networkmanager_wait_until_unmanaged $INTERNET_IFACE
            fi

            # create bridge interface
            ip link add name $BRIDGE_IFACE type bridge || die
            ip link set dev $BRIDGE_IFACE up || die
            # set 0ms forward delay
            echo 0 > /sys/class/net/$BRIDGE_IFACE/bridge/forward_delay

            # attach internet interface to bridge interface
            ip link set dev $INTERNET_IFACE promisc on || die
            ip link set dev $INTERNET_IFACE up || die
            ip link set dev $INTERNET_IFACE master $BRIDGE_IFACE || die

            ip addr flush $INTERNET_IFACE
            for x in "${IP_ADDRS[@]}"; do
                x="${x/inet/}"
                x="${x/secondary/}"
                x="${x/dynamic/}"
                x=$(echo $x | sed 's/\([0-9]\)sec/\1/g')
                x="${x/${INTERNET_IFACE}/}"
                ip addr add $x dev $BRIDGE_IFACE || die
            done

            # remove any existing entries that were added from 'ip addr add'
            ip route flush dev $INTERNET_IFACE
            ip route flush dev $BRIDGE_IFACE

            # we must first add the entries that specify the subnets and then the
            # gateway entry, otherwise 'ip addr add' will return an error
            for x in "${ROUTE_ADDRS[@]}"; do
                [[ "$x" == default* ]] && continue
                ip route add $x dev $BRIDGE_IFACE || die
            done

            for x in "${ROUTE_ADDRS[@]}"; do
                [[ "$x" != default* ]] && continue
                ip route add $x dev $BRIDGE_IFACE || die
            done

            echo "$BRIDGE_IFACE created."


