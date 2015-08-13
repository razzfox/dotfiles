dotfiles
====

To Do
----

 - create a security system port knock to allow password logins from that specific IP
 - Write a function creator like https://github.com/erichs/composure that displays ncurses history with selectable lines.
 - make a script that puts my name (and name of script, auto editing) on the top of all my dotfiles, and school files. (copies to /tmp for safety, readable by no other user). maybe use ascii art.
 - prevent clear screen when ssh ends
 - consider set -u/+u (unbound variable) and set -x/+x (print all commands) for testing scripts
 - Is this still needed in hosts.linux? # nscd --invalidate=hosts || true
 - Create a './configure, make, make install' process to learn how that works. Replace install.sh.
 - Remove # from same line as functions
 - Add space after function ()
 - tmux send to inside tmux first
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
