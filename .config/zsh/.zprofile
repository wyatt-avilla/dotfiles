if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
    # dark theme for qt apps
    export QT_STYLE_OVERRIDE=adwaita-dark
    # start hyprland only on tty1
    /home/wyatt/coding/scripts/startHyprland.sh > /dev/null
fi
