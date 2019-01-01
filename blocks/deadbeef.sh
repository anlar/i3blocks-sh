#!/usr/bin/env sh

instance=deadbeef
playing=Play
paused=Pause
stopped=Stop
hide_inactive=0

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts a:b:c:q opt; do
  case "$opt" in
    a) playing="$OPTARG" ;;
    b) paused="$OPTARG" ;;
    c) stopped="$OPTARG" ;;
    q) hide_inactive=1 ;;
  esac
done

song="$($instance --nowplaying-tf "%artist% - %title%")"
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
  1|4) deadbeef.sh --next ;;
  3|5) deadbeef.sh --prev ;;
  2) deadbeef.sh --play-pause ;;
esac

if [ "$hide_inactive" -eq 1 ] && [ "$isactive" -eq 0 ]; then
  exit 0
fi

printf "%s %s\n" "$status" "$song"
printf "%s\n" "$song"

