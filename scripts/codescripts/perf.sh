# Change relatime to noatime in fstab

echo noop | sudo tee /sys/block/sdb/queue/scheduler

sudo sysctl vm.dirty_background_ratio=90
sudo sysctl vm.dirty_ratio=90
