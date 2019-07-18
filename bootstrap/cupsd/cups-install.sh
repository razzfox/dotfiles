pacman -Sy cups ghostscript gsfonts gutenprint
systemctl enable org.cups.cupsd.service
systemctl start org.cups.cupsd.service

pacman -Sy python2 python2-pip
pip2 install pycups
curl -LO https://raw.github.com/tjfontaine/airprint-generate/master/airprint-generate.py
python2 airprint-generate.py -d /etc/avahi/services
