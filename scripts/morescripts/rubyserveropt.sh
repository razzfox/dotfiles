#!/usr/bin//bash
# Start an HTTP server from a directory
if [[ $# == 1 ]]; then
  ruby -run -e httpd . -p $1
else
  ruby -run -e httpd . -p 5000
fi
