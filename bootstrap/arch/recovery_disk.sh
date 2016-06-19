# Download ISO
# Mount ISO
# Copy ISO data partition
dd if=/ISOsdb1 of=RECOVERYPARTITIONsda4
# Mount ISO EFI partition
mount /ISOsdb2 /mnt
# Copy EFI data and loader entry
cp -var /mnt/EFI/archiso /boot/EFI
cp -va /mnt/loader/entries/archiso.conf /boot/loader/entries
