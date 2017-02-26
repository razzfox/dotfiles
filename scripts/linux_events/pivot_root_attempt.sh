sudo bash -c 'dd if=/dev/sda | gzip -c >/mnt/sdb/sda.img.gz' & while true; do sleep 1; sudo kill -USR1 $(pgrep dd); du -hs /mnt/sdb/sda.img.gz; done
gzip -cd /run/sda.img.gz | dd of=/dev/sda & while true; do sleep 1; sudo kill -USR1 $(pgrep dd); done


mkdir /tmproot
mount none /tmproot -t tmpfs
mkdir /tmproot/{proc,sys,usr,var,oldroot}
cp -ax /{bin,etc,mnt,sbin,lib,lib64,boot,root,usr,var} /tmproot/
cp -ax /{bin,etc,mnt,sbin,lib} /tmproot/
cp -ax /usr/{bin,sbin,lib} /tmproot/usr/
cp -ax /var/{account,empty,lib,local,lock,nis,opt,preserve,run,spool,tmp,yp} /tmproot/var/
cp -a /dev /tmproot/dev

pivot_root /tmproot/ /tmproot/oldroot
mount none /proc -t proc
mount none /sys -t sysfs
mount none /dev/pts -t devpts

systemctl restart sshd

umount /oldroot/proc
umount /oldroot/dev/pts
umount /oldroot/selinux
umount /oldroot/sys
umount /oldroot/var/lib/nfs/rpc_pipefs

fuser -vm /oldroot/dev

killall udevd

umount -l /oldroot/dev
umount /oldroot

mount none /dev/pts -t devpts


echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
