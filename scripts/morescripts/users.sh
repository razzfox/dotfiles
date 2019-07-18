# Learning about
who
finger
last
id
groups
users


# Doing stuff
useradd -m razz
passwd razz
#userdel razz
usermod -aG group2 razz


# Making shared folders work
chmod g+s <directory>  //set gid
setfacl -d -m g::rwx /<directory>  //set group to rwx default
setfacl -d -m o::rx /<directory>   //set other
Next we can verify:

getfacl /<directory>


# Files used
#/etc/passwd
#/etc/group
