#ssh $CRAFT -NR 10000:localhost:32400
ssh localhost -NL 10000:localhost:32400 -g

# Is this necessary?:
#grep 'GatewayPorts yes' /etc/ssh/sshd_config || echo 'GatewayPorts yes' >> /etc/ssh/sshd_config
