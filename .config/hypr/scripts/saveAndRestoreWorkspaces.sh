#!/bin/sh

workspaceFile="/tmp/savedWorkspaces"

if [ "$1" = "save" ]; then
    killall -9 swayidle
    hyprctl monitors -j | jq -r '.[] | "\(.name):\(.activeWorkspace.id)"' >$workspaceFile
    hyprctl dispatch focusmonitor HDMI-A-1 && hyprctl dispatch workspace 68 && hyprctl dispatch focusmonitor DP-1 && hyprctl dispatch workspace 69
    swayidle timeout 1 "echo went idle..." resume "$HOME/.config/hypr/scripts/saveAndRestoreWorkspaces.sh restore"
fi

if [ "$1" = "restore" ]; then
    killall -9 swayidle
    if [ -e "$workspaceFile" ]; then
        while IFS=: read -r monitorName prevWorkspace; do
            hyprctl dispatch focusmonitor "$monitorName" && hyprctl dispatch workspace "$prevWorkspace"
        done <"$workspaceFile"
        hyprctl dispatch focusmonitor DP-1
        swayidle timeout 600 "$HOME/.config/hypr/scripts/saveAndRestoreWorkspaces.sh save"
    else
        echo "File does not exist."
    fi
fi
