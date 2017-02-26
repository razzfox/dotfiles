while true; do sudo -v; sleep 60; kill -0 "$$" || return; done 2>/dev/null &
