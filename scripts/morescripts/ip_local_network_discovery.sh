for ip in 10.0.1.{1..254}; do ping -c1 -W1 10.0.1.102 & done | grep '64 bytes from' | cut -d' ' -f 4 | tr -d :
