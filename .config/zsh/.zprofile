# remove "Downloads"
[ -d "/home/wyatt/Downloads" ] && rmdir /home/wyatt/Downloads

if [ -d "/var/lib/syncthing/" ]; then
    doas chown -R syncthing /var/lib/syncthing/
    doas chmod -R 776 /var/lib/syncthing/
fi

# only execute on tty1
if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
    # dark theme for qt apps
    export QT_STYLE_OVERRIDE=adwaita-dark

    export _JAVA_AWT_WM_NONREPARENTING=1
    dbus-run-session Hyprland > /dev/null
fi
