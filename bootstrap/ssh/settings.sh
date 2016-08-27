# Protect $HOME/.ssh from other users and own group
mkdir -p -m 700 $HOME/.ssh
chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/*

# Used by shell/dotfiles-sync.sh and shell/ssh.sh
if test ! -f $HOME/.ssh/ssh_servers; then
  echo 'SSH_SERVERS=(user@example.university.edu user@example.dhcp.io user@example.local)
GHH="https://github.com""
GHS="ssh://git@github.com""
' >> $HOME/.ssh/ssh_servers
fi

chmod 600 $HOME/.ssh/ssh_servers
