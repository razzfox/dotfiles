# From: https://wiki.qemu.org/Features/HelperNetworking
#sudo mkdir -p /etc/qemu
#sudo chown root:users /etc/qemu
#sudo bash -c 'echo "allow br0" > /etc/qemu/bridge.conf'
#sudo chown root:users /etc/qemu/bridge.conf
#sudo chmod 0640 /etc/qemu/bridge.conf
#sudo chmod u+s /usr/lib/qemu/qemu-bridge-helper

source $HOME/scripts/bridgesetup.sh

qemu-system-x86_64 -enable-kvm \
-smp 2,cores=2 -m 4G \
-bios /usr/share/ovmf/ovmf_code_x64.bin \
-drive file=/dev/sda,format=raw,copy-on-read=on,cache=writeback \
-usb -device usb-tablet \
-net nic -net tap,ifname=tap0,script=no,downscript=no

#-net bridge,br=br0,helper=$HOME/scripts/bridge_setup.sh -net nic,model=virtio \
#-net nic -net tap,helper=/usr/lib/qemu/qemu-bridge-helper \

#-display none \
#-vga none \
#-parallel none \
#-serial none \
#-monitor none \

#-vga cirrus
#-vga std
#-g 1920x1080
# Sound comes through RDP? PulseAudio uses high CPU
#-soundhw hda

# Hopefully this command line option will be added soon to send guest
# ACPI shutdown signal when qemu receives SIGTERM
#-powerdown
