#!/bin/bash

for pid in $(pgrep -f $0); do
    if [ $pid != $$ ]; then
        kill $pid
    fi
done

log() {
  printf "[$$] $1" | systemd-cat
  echo "$1"
}

set +e

while clipnotify || true;
do
  log "** Selection changed"
  
  emoji_picker=$(xdotool search -class plasma.emojier || echo 0)
  clipboard=$(xclip -o -sel clip || echo "<empty clipboard>")

  if [ $emoji_picker -gt 0 ] && echo $clipboard | is-emoji ; then
    log "* Emoji picker found ($emoji_picker) : closing..."
    xdotool key --window $emoji_picker Escape Escape

    sleep 0.2

    log "> Paste emoji: $clipboard"
    xdotool key ctrl+v
  fi
done
