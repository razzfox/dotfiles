#!/bin/bash

#sudo pacman -Syu bridge-utils
#sudo apt-get install uml-utilities

if ! ip link | grep -q bridge0; then
  #Create a new bridge and change its state to up:
  sudo ip link add name bridge0 type bridge
  sudo ip link set bridge0 up
  #To add an interface (e.g. eth0) into the bridge, its state must be up:
  #Adding the interface into the bridge is done by setting its master to bridge0:
  sudo ip link set enp2s0f0 master bridge0

  #This is how to remove an interface from a bridge:
  # ip link set enp2s0f0 nomaster
  #The interface will still be up, so you may also want to bring it down:
  # ip link set enp2s0f0 down
fi

if ! ip link | grep -q tap0; then
  sudo ip tuntap add dev tap0 mode tap
  sudo ip link set tap0 up promisc on
  #sudo brctl addif br0 tap0
  sudo ip link set tap0 master bridge0
fi

sudo bridge link


#To access physical USB device connected to host from VM, you can use the option: -usbdevice host:vendor_id:product_id.
#You can find vendor_id and product_id of your device with lsusb command.
#-device usb-host,bus=controller_id.0,vendorid=0xvendor_id,productid=0xproduct_id,port=<n>
#-device nec-usb-xhci,id=xhci


# qemu-img create -f qcow2 mac_hdd.img 128G
#
# echo 1 > /sys/module/kvm/parameters/ignore_msrs (this is required)
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

############################################################################
# NOTE: Tweak the "MY_OPTIONS" line in case you are having booting problems!
############################################################################

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

qemu-system-x86_64 -enable-kvm -m 8G -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine pc-q35-2.11 \
	  -smp cores=2,threads=2,sockets=1 \
	  -usb -device usb-kbd -device usb-tablet \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=OVMF_VARS-1024x768.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
	  -device ide-drive,bus=ide.2,drive=Clover \
	  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=./'Mojave/Clover.qcow2' \
	  -device ide-drive,bus=ide.1,drive=MacHDD \
	  -drive id=MacHDD,if=none,file=/dev/sdb4,format=raw \
	  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
	  -vnc :0 \
	  -monitor stdio

#	  -device virtio-scsi-pci,id=scsi0 -drive file=/dev/sdb4,if=none,format=raw,discard=unmap,aio=native,cache=none,id=someid -device scsi-hd,drive=someid,bus=scsi0.0

if false && ip link | grep -q bridge0; then
#To delete a bridge issue the following command:
sudo ip link delete bridge0 type bridge
#This will automatically remove all interfaces from the bridge. The slave interfaces will still be up, though, so you may also want to bring them down after.
fi

if false && ip link | grep -q tap0; then
  sudo ip link delete tap0
fi

false && sudo systemctl restart dhcpcd
