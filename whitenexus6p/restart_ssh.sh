bash -c 'pkill sshd && sleep 4 && sshd -p 7299' & disown
bash -c 'pkill ssh && sleep 4 && .termux/boot/remoteForwardSSH' & disown
