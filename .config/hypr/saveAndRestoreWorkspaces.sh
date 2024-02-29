#!/bin/sh

workspaceFile="/tmp/savedWorkspaces"
fromSwayIdleID="$(pgrep swayidle)"
#echo "previous swayidle id -> $fromSwayIdleID"

if [ "$1" = "save" ]; then
    killall -9 swayidle
    #echo "-------------------------- does this work --------------------------"
    hyprctl monitors -j | jq -r '.[] | "\(.name):\(.activeWorkspace.id)"' > $workspaceFile
    echo "$workspaceFile now contains" "$(cat $workspaceFile)"
    hyprctl dispatch focusmonitor HDMI-A-1 && hyprctl dispatch workspace 68 && hyprctl dispatch focusmonitor DP-1 && hyprctl dispatch workspace 69
    swayidle timeout 1 "echo swayidle w/ timeout 1 started..." resume "~/.config/hypr/saveAndRestoreWorkspaces.sh restore"
fi

if [ "$1" = "restore" ]; then
        killall -9 swayidle
        if [ -e "$workspaceFile" ]; then
        while IFS=: read -r monitorName prevWorkspace; do
                hyprctl dispatch focusmonitor $monitorName && hyprctl dispatch workspace $prevWorkspace
                echo "restoring $prevWorkspace to monitor $monitorName"
            done < "$workspaceFile"
            hyprctl dispatch focusmonitor DP-1
            swayidle timeout 600 "~/.config/hypr/saveAndRestoreWorkspaces.sh save"
        else
            echo "File does not exist."
    fi
fi
