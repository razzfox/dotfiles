# List all groups known to system (/etc/group does not include LDAP, domain, etc)
getent group | cut -d: -f1
