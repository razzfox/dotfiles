dotfiles
====

Install
----
Run 'install/dotfiles/install.sh'. That will symlink everything from 'user' to your home from default and from the directory of your system $ID.
Run any other install script in 'install' to install that program, or initialize its settings.

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
