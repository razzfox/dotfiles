lscpu | grep "MHz"

CUR="$( echo 7299 | sudo -S cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq 2>/dev/null )"
echo -n "CPU cur MHz:           "
echo $(( $CUR / 1000 ))
CUR="$( echo 7299 | sudo -S cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq 2>/dev/null )"
echo -n "CPU cur MHz:           "
echo $(( $CUR / 1000 ))
CUR="$( echo 7299 | sudo -S cat /sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_cur_freq 2>/dev/null )"
echo -n "CPU cur MHz:           "
echo $(( $CUR / 1000 ))
CUR="$( echo 7299 | sudo -S cat /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_cur_freq 2>/dev/null )"
echo -n "CPU cur MHz:           "
echo $(( $CUR / 1000 ))

TEMP=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
echo $TEMP C

echo 7299 | sudo -S /opt/vc/bin/vcdbg reloc | grep 'free block'
