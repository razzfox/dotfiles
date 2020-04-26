test -n "$1" && \
#ssh -R ${1}:localhost:${1} u0_a171@craft.dhcp.io -p 7299 -N -o 'ExitOnForwardFailure yes' & disown
nohup bash -c "while sleep 2; do ssh -R ${1}:localhost:${1} u0_a171@craft.dhcp.io -p 7299 -N -o 'ExitOnForwardFailure yes'; done">/dev/null & disown
