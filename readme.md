dotfiles
====

Install
----
Run 'install.sh'. That will symlink everything from 'user' to your home from default and from the directory of your system $ID.
Run any other install script in 'install' to install that program, or initialize its settings (including Bash).

Explanations
----
The user directory has 'skeleton' configurations, which means that the directories overlay existing directories, symlinking files into them, but leave all other files in the destination directory untracked.
(Note: there are files that begin with '.' that are typically hidden).
User or system files that require some kind of modification, are found in 'install' as a script.
(I've found that I have never used saved system files 'as is', so keeping a skeleton for system configuration is a waste of time; every system I have ever set up is different).
In contrast, the whole contents of directories in 'config' are used for configuration, so files can be added or removed here, while automatically being tracked.
(And 'config' directories contain files that I modify all the time, so they should be easy for me to find).

To Do
----
 - Everything in set_term.sh needs to be reevaluated and redone. forget if none of it works on old debian.
 - What if tmux was simply an output-capture program that took shell commands directly, and then ran a shell. Not a windowing-plexer that just runs bash loops.
   It can have its own run loop. panels are kept in a history. they replace each other. they can be piped to each other. curses or live updating apps can be pinned.
   but the point is to keep with the linux philosophy, but resolve the issue that the terminal is only a character display.
 - create a security system port knock to allow password logins from that specific IP
 - Write a function creator like https://github.com/erichs/composure that displays ncurses history with selectable lines.
 - make a script that puts my name (and name of script, auto editing) on the top of all my dotfiles, and school files. (copies to /tmp for safety, readable by no other user).
   maybe use ascii art.
 - prevent clear screen when ssh ends
 - consider set -u/+u (unbound variable) and set -x/+x (print all commands) for testing scripts
 - Is this still needed in hosts.linux? # nscd --invalidate=hosts || true
 - Create a './configure, make, make install' process to learn how that works. Replace install.sh.
 - Remove # from same line as functions
 - Add space after function ()
 - tmux send control command to inside tmux first
 - Look into saving bash env with the following code:
unset _monotone _python _tar _xz
for i in $(declare -f | grep '^\<.*\> ()'); do
  declare -fx $i
done
 - Look into using more HERE documents:
 yum install $1 << CONFIRM
y
CONFIRM


ACHTUNG!
----
    Das machine is nicht fur gerfingerpoken und mittengrabben.
        Ist easy schnappen der Sprinngwerk, blowenfusen und
                poppencorken mit spitzensparken.
    Ist nicht fur gewerken by das Dummkopfen.  Das rubbernecken
            sightseeren keepen hands in das Pockets.
                Relaxen und watch das blinkenlights...


License
----

                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                        Version 2, December 2004

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

    0. You just DO WHAT THE FUCK YOU WANT TO.
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
