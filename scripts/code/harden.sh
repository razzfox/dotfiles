# Do not respond to ping
echo 'net.ipv4.icmp_echo_ignore_all = 1' >> /etc/sysctl.d/icmp_echo_ignore_all.conf
#echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
sysctl -p --system

# Settings for sshd
echo 'PasswordAuthentication no
Port 22729' >> /etc/ssh/sshd_config
systemctl restart sshd

# Do not respond to all ports using iptables
echo '# Setting default policies:
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Exceptions to default policy
iptables -A INPUT -p tcp --dport 80 -j ACCEPT       # HTTP
iptables -A INPUT -p tcp --dport 443 -j ACCEPT      # HTTPS
iptables -A INPUT -p tcp --dport 22729 -j ACCEPT    # SSH
iptables -A INPUT -p tcp --dport 8384 -j ACCEPT     # Syncthing
iptables -A INPUT -p tcp --dport 9091 -j ACCEPT     # Transmission BitTorrent
' > /etc/iptables/block_all_ports.rules
