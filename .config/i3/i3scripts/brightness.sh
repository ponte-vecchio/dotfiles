#!/bin/sh

brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
brightness_percent=$(($brightness/75))
echo "$brightness_percent%"
