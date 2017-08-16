# Create
#xfconf-query -c xfce4-session -p /general/LockCommand -s "sudo chvt 8" --create -t string

# Update
#xfconf-query -c xfce4-session -p /general/LockCommand -s "sudo chvt 8"

# This feature is not yet merged into the arch xfce4 package

# So just put 'sudo chvt 8' into /usr/bin/xflock4
echo 'sudo chvt 8' | sudo tee /usr/bin/xflock4
