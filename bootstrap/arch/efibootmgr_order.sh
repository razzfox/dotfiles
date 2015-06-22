# delete boot order
efibootmgr -O

# set boot order
efibootmgr -o 0000,0001,0080,0081
