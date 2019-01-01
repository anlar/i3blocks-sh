#!/usr/bin/env sh

instance=battery_BAT0
state_chr=CHR
state_dis=DIS
state_full=FULL
low_threshold=50
low_color=#FFAE00

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
fi

while getopts c:d:f:t:u: opt; do
  case "$opt" in
    c) state_chr="$OPTARG" ;;
    d) state_dis="$OPTARG" ;;
    f) state_full="$OPTARG" ;;
    t) low_threshold="$OPTARG" ;;
    u) low_color="$OPTARG" ;;
    *) exit 1 ;;
  esac
done

device="/org/freedesktop/UPower/devices/$instance"
percentage=$(upower -i "$device" | grep percentage | awk '{print $2}' | sed 's/.$//')
state=$(upower -i "$device" | grep state | awk '{print $2}')

if [ -z "$percentage" ]; then
  echo >&2 "battery_upower: percentage value for $device not found, aborting"
  exit 1
fi

case "$state" in
  charging|pending-charge)
    state_name="$state_chr" ;;
  discharging|pending-discharge|empty)
    state_name="$state_dis" ;;
  fully-charged)
    state_name="$state_full" ;;
esac

printf "%s%% %s\n" "$percentage" "$state_name"
printf "%s%%\n" "$percentage"

if [ "$state" = discharging ] && [ "$percentage" -lt "$low_threshold" ]; then
  printf "%s\n" "$low_color"
fi
