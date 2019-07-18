#su -c "setcap 'cap_net_bind_service=+ep' $(which ruby)"
# Start an HTTP server from a directory
ruby -run -e httpd . -p 80
