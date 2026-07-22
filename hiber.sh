#!/vendor/bin/sh
#
#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear
#

VERSION=2.0
echo "Current hibernation script version is $VERSION"


sda=`ls -l /dev/block/by-name/swap_a | awk '{print $NF}' | awk -F'[/]' '{print $4}'`
major=`ls -l /dev/block/${sda} | awk '{print $5}' | grep -o '[0-9]*'`
minor=`ls -l /dev/block/${sda} | awk '{print $6}' | grep -o '[0-9]*'`
echo "${major}:${minor}" > /sys/power/resume
sleep 3

echo "enable swap partition"
mkswap /dev/block/mmcblk0p84
swapon /dev/block/mmcblk0p84 -p 0

echo 100 > /proc/sys/vm/swappiness
echo 0 > /sys/power/image_size
echo "UI turn off"
cat /proc/swaps

sync

#drop caches
echo "drop page caches"

# In hiber.sh — add a guard before the drop_caches loop iteration
if [ -f /sys/power/state ] && grep -q "disk" /sys/power/state; then
    break  # Hibernation path is already active — stop evicting
fi
echo 3 > /proc/sys/vm/drop_caches

echo "Start adsp shutdown"
while [ "$(cat /sys/class/remoteproc/remoteproc0/state)" != "offline" ]; do
echo "stop" > /sys/class/remoteproc/remoteproc0/state
sleep 1
done

echo "end of adsp shutdown"

echo "Start cdsp shutdown"

while [ "$(cat /sys/class/remoteproc/remoteproc1/state)" != "offline" ]; do
echo "stop" > /sys/class/remoteproc/remoteproc1/state
sleep 1
done

echo shutdown > /sys/power/disk
while true
do
echo 3 > /proc/sys/vm/drop_caches
sync
done
