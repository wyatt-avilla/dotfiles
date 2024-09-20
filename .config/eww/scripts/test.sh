#!/bin/bash

title=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
    string:'Metadata' | grep "xesam:title" -A 1 | tail -n 1 | cut -d '"' -f2)

artist=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
    string:'Metadata' | grep "xesam:artist" -A 2 | tail -n 1 | cut -d '"' -f2)

playback_status=$(
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
        /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
        string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' |
        tail -n 1 | cut -d '"' -f2
)

echo "$title - $artist"

echo "$playback_status"
