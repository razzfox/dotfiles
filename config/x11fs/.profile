#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Test for terminal
test -t 0 || return 1

if test "$TERM" = linux -a "$(tty)" = "/dev/tty1"; then
  startx
fi
