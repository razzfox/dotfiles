bat() {
  if ! test -d /sys/class/power_supply/BAT0; then
    echo "100%"
    return 0
  fi

  BAT=$(echo "scale=1; " $(echo "scale=3; $(cat /sys/class/power_supply/BAT0/charge_now) / $(cat /sys/class/power_supply/BAT0/charge_full) * 100" | bc -l) "/ 1" | bc -l | head -c -1)
  echo -n "${BAT}%,"
  cat /sys/class/power_supply/BAT0/status

  test "${BAT%%.*}" -ge 31
}


bat "$@"
