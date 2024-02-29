# remove "Downloads"
[ -d "/home/wyatt/Downloads" ] && rmdir /home/wyatt/Downloads

# only execute on tty1
if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
    # dark theme for qt apps
    export QT_STYLE_OVERRIDE=adwaita-dark
    /home/wyatt/coding/scripts/startHyprland.sh > /dev/null
fi
