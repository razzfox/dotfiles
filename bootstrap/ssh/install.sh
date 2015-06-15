# Protect ~/.ssh from other users and own group
mkdir -p -m 700 $HOME/.ssh
chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/*

test -f $HOME/.ssh/ssh_servers || echo 'SERVERS=(user@example.university.edu user@example.dhcp.io user@example.local)
GH_WWW="https://github.com"
GH_SSH="git@github.com"
' >> $HOME/.ssh/ssh_servers

chmod 600 $HOME/.ssh/ssh_servers
