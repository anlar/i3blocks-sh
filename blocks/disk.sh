#!/usr/bin/env sh

instance=$(df -hl --output='source' |grep '/dev' -m 1)
low_threshold=50
low_color=#FFAE00
hide_inactive=0

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts t:u:q opt; do
  case "$opt" in
    t) low_threshold="$OPTARG" ;;
    u) low_color="$OPTARG" ;;
    q) hide_inactive=1 ;;
    *) exit 1 ;;
  esac
done

available=$(df -h "$instance" --output='avail' | sed 1d | awk '{print $1}')
percentage=$(df -h "$instance" --output='pcent' | sed 1d | awk '{sub( "%", "", $1); print $1}')

if [ "$percentage" -lt "$low_threshold" ]; then
  if [ $hide_inactive -eq 1 ]; then
    exit 0
  else
    printf "%s\n" "$available"
    printf "%s\n" "$available"
  fi
else
  printf "%s\n" "$available"
  printf "%s\n" "$available"
  printf "%s\n" "$low_color"
fi
