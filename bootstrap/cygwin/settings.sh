# Set cygwin home directory to Windows user home
exec mkpasswd -l -c -p "$(cygpath -H)" > /etc/passwd

# Links
ln -s AppData/Local/Microsoft/Windows/Themes
ln -s AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup
ln -s AppData/Roaming/Microsoft/Internet\ Explorer/Quick\ Launch/User\ Pinned/TaskBar
