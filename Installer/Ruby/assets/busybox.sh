#!/bin/bash
mount -o rw,remount /system
rm /system/bin/busybox
rm /system/xbin/busybox
dd if=/data/local/tmp/busybox of=/system/bin/busybox
chmod 755 /system/bin/busybox
rm /system/bin/dexopt-wrapper
rm /system/xbin/dexopt-wrapper
dd if=/data/local/tmp/dexopt-wrapper of=/system/bin/dexopt-wrapper
chmod 755 /system/bin/dexopt-wrapper