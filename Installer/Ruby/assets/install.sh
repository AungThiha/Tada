#!/bin/bash
mount -o rw,remount /system
mv /system/framework/$1 /system/framework/$1.orig
dd if=/data/local/tmp/$1 of=/system/framework/$1
chmod 644 /system/framework/$1