# Fix CUPSd as per this bug: https://bugs.launchpad.net/ubuntu/+source/cups/+bug/516018
# Claims to be fixed, but apparently is not

echo 'ServerAlias *' >> /etc/cups/cupsd.conf
