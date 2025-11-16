#!/bin/env bash

echo "Detecting Joystick..."

sleep 1 

JOY_STICK_EVENT=$(cat /proc/bus/input/devices | grep "js" | awk '{print$2}' | sed 's/.*Handlers=\(event[0-9]\+\).*/\1/')

if [ -n "$JOY_STICK_EVENT" ]; then
    echo "Joystick event device: $JOY_STICK_EVENT"
else
    echo "Joystick not found."
    exit 1
fi

echo "Setting up Xbox controller emulation..."

sleep 1

for joystick in "${JOY_STICK_EVENT[@]}"; do
  
xboxdrv --evdev /dev/input/$joystick \
   --evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_RX=x2,ABS_RZ=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
   --axismap -Y1=Y1,-Y2=Y2 \
   --evdev-keymap   BTN_TOP=x,BTN_TRIGGER=y,BTN_THUMB2=a,BTN_THUMB=b,BTN_BASE3=back,BTN_BASE4=start,BTN_BASE=lb,BTN_BASE2=rb,BTN_TOP2=lt,BTN_PINKIE=rt,BTN_BASE5=tl,BTN_BASE6=tr \
   --mimic-xpad --silent
done
