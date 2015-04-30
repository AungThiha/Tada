#!/bin/bash
mount -o rw,remount /system
rm /system/framework/$1
mv /system/framework/$1.orig /system/framework/$1
chmod 644 /system/framework/$1