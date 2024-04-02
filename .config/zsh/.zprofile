# remove "Downloads"
[ -d "/home/wyatt/Downloads" ] && rmdir /home/wyatt/Downloads

# me when codio
mkdir -p /var/run/user/1000/firenvim
echo "codio" > /var/run/user/1000/firenvim/.wakatime-project

# only execute on tty1
if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
    # dark theme for qt apps
    export QT_STYLE_OVERRIDE=adwaita-dark

    export _JAVA_AWT_WM_NONREPARENTING=1
    dbus-run-session Hyprland > /dev/null
fi
