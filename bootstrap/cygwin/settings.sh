# Set Home directory to windows user home
exec mkpasswd -l -c -p "$(cygpath -H)" > /etc/passwd
