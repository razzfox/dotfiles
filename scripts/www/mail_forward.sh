socat TCP4-LISTEN:25,fork,reuseaddr TCP4:craft.dhcp.io:2500 & disown
socat TCP4-LISTEN:110,fork,reuseaddr TCP4:craft.dhcp.io:1100 & disown
