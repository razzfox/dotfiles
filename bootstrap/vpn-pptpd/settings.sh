echo "option /etc/ppp/pptpd-options
localip 172.16.36.1
remoteip 172.16.36.2-254" > /etc/pptpd.conf

echo "name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
ms-dns 8.8.8.8
ms-dns 8.8.4.4" > /etc/ppp/pptpd-options

echo "user     pptpd     pass   *" >> /etc/ppp/chap-secrets

echo "# Enable packet forwarding
net.ipv4.ip_forward=1" >> /etc/sysctl.d/99-sysctl.conf

sysctl --system

systemctl enable pptpd.service

systemctl start pptpd.service
