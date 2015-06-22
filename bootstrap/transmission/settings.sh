systemctl stop transmission && nano /var/lib/transmission/.config/transmission-daemon/settings.json && systemctl start transmission

chown -R transmission:transmission /var/lib/transmission/
chmod 0644 /var/lib/transmission/.config/transmission-daemon/*
