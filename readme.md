dotfiles
====

Install
----
1. Run 'install.sh'. That will symlink everything from 'userskel/default', and from 'userskel/{system $ID}' to your home dir.
2. Run other install scripts in 'install/' for specific programs to initialize settings (including Bash functions).

Explanation
----
 - User or system files that require customization at install time, are found in 'install' as a setup script.
 - The whole contents of directories in 'config' can be added or modified without being scripted, since it will be files that I modify all the time, not only at install time.

To Do
----
 - Everything in set_term.sh needs to be reevaluated and redone. forget if none of it works on old debian.
 - Can I make tmux into a REPL that takes shell commands directly, and runs that program. Not a windowing-plexer that just runs bash loops. Panels are kept in a history. they can replace each other, they can be piped to each other. curses or live updating apps can be pinned.
 - create a port knock to allow password logins from that specific IP
 - Write a function creator like https://github.com/erichs/composure that displays ncurses history with selectable lines.
 - consider set -u/+u (unbound variable) and set -x/+x (print all commands) for testing scripts
 - Is this still needed in hosts.linux? # nscd --invalidate=hosts || true
 - Create a './configure, make, make install' process to learn how that works and replace install.sh.
 
todo: mv echo-command output to stderr.
todo: tab complete expands binary to full path
todo: rm deletes whole folder when single argument without y/n. maybe just always use y/n. also maybe also make rm echo a warning and only use trash.
todo: mv rm, stop verbose output and instead use an output that rewrites the current line. also only tree the first or second level.
tab complete to expand full binary path.

pacman idea for git root filesystem: have all the install messages log into the git commit message.
#pacmd list-sinks | grep -e 'name:' -e 'index'

#!/bin/bash
USER_NAME=$(w -hs | awk -v vt=tty$(fgconsole) '$0 ~ vt {print $1}')
USER_ID=$(id -u "$USER_NAME")
HDMI_STATUS=$(</sys/class/drm/card0/*HDMI*/status)

export PULSE_SERVER="unix:/run/user/"$USER_ID"/pulse/native"

if [[ $HDMI_STATUS == connected ]]
then
  sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:hdmi-stereo+input:analog-stereo
else
  sudo -u "$USER_NAME" pactl --server "$PULSE_SERVER" set-card-profile 0 output:analog-stereo+input:analog-stereo
fi
a untiliny would scan / for changes to text files, then it would query the ownership of the files by package, so that I can understand the changes.

maybe an update would be to revert to master (plain install versions that do not conflict with a pacnew) and then merge master into current branch.

directories that are ignored would be mnt tmp bin var usr.
todo: A mv log would be able to show where and when a file was moved, and with what group of files. it would also show a rename log, and be similar to a delete log and trash log. All the basic file bins could get in on the action, ls, mv, rn, trash, delete, cp.
Convert the bootstrap install files from Syu to Sy.
Create a shell file backup option for >> and > file writes.
