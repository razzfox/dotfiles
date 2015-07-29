# Save space on root by moving plex to home partition
mv -v  /var/lib/plex /home/plex
ln -s /var/lib/plex /home/plex
