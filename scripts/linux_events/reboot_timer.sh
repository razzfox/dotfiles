#!/bin/bash
reboot_timer () {
  test $EUID = 0 || return
  test -e /var/run/reboot_timer.pid && kill $(cat /var/run/reboot_timer.pid) && rm /var/run/reboot_timer.pid && return 1

  echo $$ >/var/run/reboot_timer.pid
  sleep $1

  test -e /.reboot || return
  rm /.reboot
  shutdown -r now

  echo 1 > /proc/sys/kernel/sysrq
  sleep 1
  echo r > /proc/sysrq-trigger
  sleep 1
  echo e > /proc/sysrq-trigger
  sleep 1
  echo i > /proc/sysrq-trigger
  sleep 1
  echo s > /proc/sysrq-trigger
  sleep 1
  echo u > /proc/sysrq-trigger
  sleep 1
  echo b > /proc/sysrq-trigger
}

reboot_timer "$@"

echo "To cancel reboot in $1 seconds, run 'kill $(cat /var/run/reboot_timer.pid)'"
