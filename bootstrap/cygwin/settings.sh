# Set Home directory to windows user home
mkpasswd -l -c -p "$(cygpath -H)" > /etc/passwd
logout
