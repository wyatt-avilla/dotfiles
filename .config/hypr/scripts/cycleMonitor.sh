#!/bin/bash

focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$1" = "move" ]; then
	hyprctl dispatch split-changemonitor next
fi

if [ "$focused_monitor" = "DP-1" ]; then
	hyprctl dispatch focusmonitor HDMI-A-1
else
	hyprctl dispatch focusmonitor DP-1
fi
