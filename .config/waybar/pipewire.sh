masterInfo=$(amixer -M get Master)

if [[ $masterInfo == *"[on]"* ]]; then 
    volume=$(echo "$masterInfo" | sed -n 's/.*\[\(.*\)%\].*/\1/p')
    if [[ $volume -le 100 && $volume -gt 50 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \"$volume%\"}"
    elif [[ $volume -le 50 && $volume -gt 25 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \"$volume%\"}"
    elif [[ $volume -le 25 && $volume -gt 0 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \"$volume%\"}"
    fi
else
    echo "{\"class\": \"muted\", \"text\": \"MUTE\"}"
fi
