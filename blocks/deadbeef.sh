#!/usr/bin/env sh

instance=deadbeef
playing=Play
paused=Pause
stopped=Stop
max_length=1000
hide_inactive=0

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts a:b:c:m:q opt; do
  case "$opt" in
    a) playing="$OPTARG" ;;
    b) paused="$OPTARG" ;;
    c) stopped="$OPTARG" ;;
    m) max_length="$OPTARG" ;;
    q) hide_inactive=1 ;;
    *) exit 1 ;;
  esac
done

title="$($instance --nowplaying-tf "%artist% - %title%" | cut -c -$max_length)"
short_title="$($instance --nowplaying-tf "%title%")"
isplaying="$($instance --nowplaying-tf "%isplaying%")"
ispaused="$($instance --nowplaying-tf "%ispaused%")"
isactive=1

if [ "$isplaying" = '1' ]; then
  status="$playing"
else
  if [ "$ispaused" = '1' ]; then
    status="$paused"
  else
    status="$stopped"
    isactive=0
  fi
fi

case "$BLOCK_BUTTON" in
  1|4) "$instance" --next ;;
  3|5) "$instance" --prev ;;
  2) "$instance" --play-pause ;;
esac

if [ "$hide_inactive" -eq 1 ] && [ "$isactive" -eq 0 ]; then
  exit 0
fi

printf "%s %s\n" "$status" "$title"
printf "%s %s\n" "$status" "$short_title"
