if ! ip link show br0; then
  sudo systemctl stop dhcpcd

  sudo ip link add br0 type bridge

#  #sudo ip link set down enp2s0
#  sudo ip link set enp2s0 promisc on
#  sudo ip link set up enp2s0
  sudo ip link set enp2s0 master br0
  sudo ip addr flush enp2s0
#  sudo ip route flush enp2s0

#  #sudo ip link set down wlp3s0
#  sudo ip link set wlp3s0 promisc on
#  sudo ip link set up wlp3s0
#  sudo ip link set wlp3s0 master br0
#  sudo ip addr flush wlp3s0
#  sudo ip route flush wlp3s0

  sudo ip link set up dev br0

  # Set up NAT in iptables router
  sudo sysctl -w net.ipv4.ip_forward=1
  sudo sysctl -w net.ipv6.ip_forward=1
  sudo iptables --table nat --append POSTROUTING --out-interface enp2s0 -j MASQUERADE
  sudo iptables --insert FORWARD --in-interface br0 -j ACCEPT

  sudo systemctl start dhcpcd@br0
fi

if ! ip link show tap0; then
  sudo ip tuntap add dev tap0 mode tap group users
  #user $USER

  sudo ip link set up tap0

  sudo ip addr add 0.0.0.0 dev tap0

  sudo ip link set tap0 master br0
  sudo ip addr flush tap0
fi
