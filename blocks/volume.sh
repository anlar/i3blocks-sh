#!/usr/bin/env sh

instance=Master
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

mute=$(amixer -D pulse get "$instance" | grep -c '\[off\]')

if [ "$mute" -gt 0 ] ; then
  volume="$sound_off"
else
  volume="$sound_on "$(amixer -D pulse get "$instance" | grep 'Left:' | awk -F'[][]' '{ print $2 }')
fi

case "$BLOCK_BUTTON" in
  1|4) amixer -q -D pulse set Master "$step"+ ;;
  3|5) amixer -q -D pulse set Master "$step"- ;;
  2) amixer -q -D pulse sset Master toggle ;;
esac

printf "%s\n" "$volume"
printf "%s\n" "$volume"
