#!/system/bin/sh
#
#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear
#

VERSION=2.0
echo "Current hibernation script version is $VERSION"

echo Y > /sys/module/printk/parameters/ignore_loglevel
echo N > /sys/module/printk/parameters/console_suspend
echo 0 > /d/tracing/tracing_on

# Turn BT off. Here keyevents (23:KEYCODE_DPAD_CENTER, 22:KEYCODE_DPAD_RIGHT)
# are used to allow this script to turn off BT.
am start -a android.bluetooth.adapter.action.REQUEST_DISABLE && input keyevent 23 && input keyevent 22 && input keyevent 23

echo none > /sys/bus/platform/devices/a600000.ssusb/mode

killall qcarcam_edrm_rvc
killall qcarcam_test
killall qcarcam_rvc

sleep 10

echo "enable swap partition"
mkswap /dev/block/mmcblk0p82
swapon /dev/block/mmcblk0p82 -p 0

echo "UI turn off"
cat /proc/swaps

sync

#drop caches
echo "drop page caches"

sleep 2
echo related > /sys/bus/msm_subsys/devices/subsys2/restart_level
echo "Start adsp shutdown"
echo 0 > /sys/kernel/boot_adsp/boot
echo "end of adsp shutdown"
echo "Start cdsp shutdown"
echo 0 > /sys/kernel/boot_cdsp/boot
echo "end of cdsp shutdown"

hiber_attempts="1"
while true
do
  echo 3 > /proc/sys/vm/drop_caches
  echo 1 > /sys/module/lpm_levels/parameters/sleep_disabled
  sync
  #hibernate
  echo "Start Hibernation"
  echo 8 > /proc/sys/kernel/printk

  echo shutdown > /sys/power/disk
  echo disk > /sys/power/state
  if [ $? -eq 0 ]
  then
	echo "Hibernation Successful!"
	break
  else
	echo "Hibernation failed!" >&2

	if [ "$hiber_attempts" -ge "5" ]
	then
	  echo "Fatal: Hibernation attemps >= 5" >&2
	  echo c > /proc/sysrq-trigger
	fi
  fi
  hiber_attempts=$((hiber_attempts + 1))
  sleep 2
done

# Post Restore
echo 1 > /sys/kernel/boot_adsp/boot
echo 1 > /sys/kernel/boot_cdsp/boot
setprop persist.vendor.usb.config diag,adb
echo peripheral > /sys/bus/platform/devices/a600000.ssusb/mode
swapoff /dev/block/mmcblk0p82
echo Y > /sys/module/printk/parameters/console_suspend
echo "restart keymaster service and keystore daemon"
killall android.hardware.keymaster@4.1-service-qti
pkill keystore2
echo "restart qseecomd deamon"
pkill qseecomd
