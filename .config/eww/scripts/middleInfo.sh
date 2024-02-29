#!/bin/bash

#page_icon="./assets/page.png"
obsidian_icon="./assets/obsidian.png"
nvim_icon="./assets/nvim.png"
spotify_icon="./assets/spotify.png"
terminal_icon="./assets/terminal.png"
chrome_icon="./assets/chrome.png"
drive_icon="./assets/drive.png"
docs_icon="./assets/docs.png"
gmail_icon="./assets/gmail.png"
youtube_icon="./assets/youtube.png"
chatgpt_icon="./assets/chatgpt.png"
emerge_icon="./assets/gentoo.png"

currentWindow=$(hyprctl activewindow -j)
title=$(echo "$currentWindow" | jq -r '.title')
class=$(echo "$currentWindow" | jq -r '.class')

blob_visible="true"
display_title=$title
icon_path=""
icon_visible="true"

json_ret() {
  printf '{"blob_visible":"%s","display_title":"%s","icon":{"path":"%s","icon_visible":%s}}\n' \
    "$blob_visible" "$display_title" "$icon_path" "$icon_visible"
  exit
}

getSong() {
  if [[ "$1" == "spotify" ]]; then
    songInfo=$(hyprctl clients -j | jq -r '.[] | select(.class == "Spotify") | .title')
    if [[ "$songInfo" == "Spotify Premium" ]]; then
      getWindow
    else
      formatted_title=$(echo "$songInfo" | awk -F ' - ' '{print $2 " - " $1}')
      display_title="$formatted_title"
      icon_path=$spotify_icon
    fi
  else
    song=$(nc -W 1 -U ~/.cache/ncspot/ncspot.sock | jq '.playable.title' | tr -d '"')
    artist=$(nc -W 1 -U ~/.cache/ncspot/ncspot.sock | jq '.playable.artists[0]' | tr -d '"')
    display_title="$song - $artist"
    icon_path=$spotify_icon
  fi
}

getWindow() {
  if [[ "$class" == "kitty" ]]; then
    if [[ "$title" == *"nvim"* ]]; then
      icon_path=$nvim_icon
      subtracted_string=${title#nvim }
      display_title="editing $subtracted_string"
    elif [[ "$title" == *"emerge"* ]]; then
      icon_path=$emerge_icon
    else
      icon_path=$terminal_icon
    fi

  elif [[ "$class" == "google-chrome" ]]; then
    display_title="${title// - Google Chrome/}"
    if [[ "$title" == *"Drive"* ]]; then
      icon_path=$drive_icon
      display_title="viewing ${display_title// - Google Drive/}"
    elif [[ "$title" == *"Docs"* ]]; then
      display_title="${display_title// - Google Docs/}"
      icon_path=$docs_icon
    elif [[ "$title" == *"YouTube"* ]]; then
      icon_path=$youtube_icon
      display_title="${display_title// - YouTube/}"
    elif [[ "$title" == *"Gmail"* ]] || [[ "$title" == *"Mail"* ]]; then
      icon_path=$gmail_icon
      display_title="${display_title// - Gmail/}"
      display_title="${display_title// - UC Santa Cruz Mail/}"
    elif [[ "$title" == *"ChatGPT"* ]]; then
      icon_path=$chatgpt_icon
    else
      icon_path=$chrome_icon
    fi

  elif [[ "$class" == "Spotify" ]]; then
    icon_path=$spotify_icon
  elif [[ "$class" == "obsidian" ]]; then
    icon_path=$obsidian_icon
    display_title="${display_title// - notes - Obsidian*/}"
  fi

  if [ "${#display_title}" -gt 70 ]; then # this should be done in css instead
    display_title="${display_title:0:70}..."
  fi
}

curr_stream=""
if wpctl status | grep spotify >/dev/null; then
  curr_stream="spotify"
elif wpctl status | grep ncspot >/dev/null; then
  curr_stream="ncspot"
fi

# generate titles
if hyprctl clients -j | jq -e '.[] | select(.class == "kitty" and (.title | strings | contains("emerge")))' >/dev/null; then
  icon_path=$emerge_icon
  display_title=$(hyprctl clients -j | jq -e '.[] | select(.class == "kitty" and (.title | strings | contains("emerge")))' | jq -r '.title')

  if [[ "$display_title" == *"emerge: "* ]]; then
    display_title="${display_title//emerge: /}"
  fi

elif [ -n "$curr_stream" ]; then
  getSong $curr_stream
else
  getWindow
fi

if [ -z "$display_title" ] || [[ "$display_title" == "null" ]]; then
  blob_visible="false"
  icon_visible="false"
fi

if [ -z "$icon_path" ]; then
  icon_visible="false"
fi

json_ret
