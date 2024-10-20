# only execute on tty1
if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
    # dark theme for qt apps
    export QT_STYLE_OVERRIDE=adwaita-dark

    export _JAVA_AWT_WM_NONREPARENTING=1
    dbus-run-session Hyprland > /dev/null
fi
