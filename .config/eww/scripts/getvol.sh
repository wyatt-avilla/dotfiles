#!/bin/sh
wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/^[^.]*\.//'

