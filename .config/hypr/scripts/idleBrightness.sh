#!/bin/bash

systemBrightnessFile="/sys/class/backlight/acpi_video0/brightness"
prevBrightnessFile="/tmp/prevBrightness.tmp"

if [ "$1" = "startIdle" ]; then
    cat $systemBrightnessFile >$prevBrightnessFile
    cat $prevBrightnessFile
    echo "0" | doas tee $systemBrightnessFile
fi

if [ "$1" = "endIdle" ]; then
    cat $prevBrightnessFile | doas tee $systemBrightnessFile
fi

if [ "$1" = "finalIdle" ]; then
    if ! pgrep -x "emerge" >/dev/null && ! pgrep -x "make" >/dev/null; then
        loginctl suspend
    fi
fi
