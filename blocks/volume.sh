#!/usr/bin/env sh

instance=$(pactl list sinks short | head -1 | awk '{print $2}' |sed 's/.*\.//')
step='5%'
sound_on='On'
sound_off='Off'

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts o:n:s: opt; do
  case "$opt" in
    o) sound_on="$OPTARG" ;;
    n) sound_off="$OPTARG" ;;
    s) step="$OPTARG" ;;
    *) exit 1 ;;
  esac
done

sink=$(pactl list sinks short | grep "$instance" | awk '{print $1}')
mute=$(pactl list sinks | grep "Sink #$sink" -A 999999 | grep Mute | head -n1 | awk '{print $2}')

if [ "$mute" = "yes" ] ; then
  volume="$sound_off"
else
  volume="$sound_on $(pactl list sinks | grep "Sink #$sink" -A 999999 | grep -P '\tVolume' | grep -P '\d+(?=%)' -o | head -1)%"
fi

case "$BLOCK_BUTTON" in
  1|4) pactl set-sink-volume "$sink" +"$step" ;;
  3|5) pactl set-sink-volume "$sink" -"$step" ;;
  2) pactl set-sink-mute "$sink" toggle ;;
esac

printf "%s\n" "$volume"
printf "%s\n" "$volume"
