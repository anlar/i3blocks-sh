#!/usr/bin/env sh

instance=$(pactl list sinks short | head -1 | awk '{print $2}' |sed 's/.*\.//')
step='5%'
no_sound='Off'

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts t:u:q opt; do
  case "$opt" in
    n) no_sound="$OPTARG" ;;
    s) step="$OPTARG" ;;
  esac
done

sink=$(pactl list sinks short | grep "$instance" | awk '{print $1}')
mute=$(pactl list sinks | grep "Sink #$sink" -A 999999 | grep Mute | head -n1 | awk '{print $2}')

if [ "$mute" = "yes" ] ; then
  volume="$no_sound"
else
  volume="$(pactl list sinks | grep "Sink #$sink" -A 999999 | grep -P '\tVolume' | grep -P '\d+(?=%)' -o | head -1)%"
fi

case "$BLOCK_BUTTON" in
  1|4) pactl set-sink-volume "$sink" +"$step" ;;
  3|5) pactl set-sink-volume "$sink" -- -"$step" ;;
  2) pactl set-sink-mute "$sink" toggle ;;
esac

printf "%s\n" "$volume"
printf "\n"
