#socat TCP4-LISTEN:5900,fork,reuseaddr TCP4:10.0.1.3:5900 & disown
socat TCP4-LISTEN:5900,fork,reuseaddr TCP4:10.0.1.3:5900
