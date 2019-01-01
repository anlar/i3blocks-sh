#!/usr/bin/env sh

icons=''
state_chr=' CHR'
state_dis=' DIS'
state_full=' FULL'
is_short=0

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
else
  instance=$(upower -e | awk -vORS=, -F'/' '$NF ~ /battery/ || $NF ~ /ups/ || $NF ~ /line_power/ {print $NF}' | tr '\n' ',' | sed 's/,$//')
fi

while getopts c:d:f:i:n:s opt; do
  case "$opt" in
    c) state_chr="$OPTARG" ;;
    d) state_dis="$OPTARG" ;;
    f) state_full="$OPTARG" ;;
    i) icons="$OPTARG" ;;
    n) instance="$OPTARG" ;;
    s) is_short=1 ;;
    *) exit 1 ;;
  esac
done

status=''

count=1
for i in $(echo "$instance" | sed "s/,/ /g"); do
  device="/org/freedesktop/UPower/devices/$i"
  icon=$(echo "$icons" | awk -v var="$count" -F',' '{print $var}')

  if [ "$i" = 'line_power_AC' ]; then
    is_on=$(upower -i "$device" | grep online | awk '{print $2}')

    if [ "$is_on" = yes ]; then
      status="$status$icon "
    fi
  else
    percentage=$(upower -i "$device" | grep percentage | awk '{print $2}' | sed 's/.$//')

    if [ "$is_short" = 1 ]; then
      status="$status$icon$percentage% "
    else
      state=$(upower -i "$device" | grep state | awk '{print $2}')

      case "$state" in
        charging|pending-charge)
          state_name="$state_chr" ;;
        discharging|pending-discharge|empty)
          state_name="$state_dis" ;;
        fully-charged)
          state_name="$state_full" ;;
      esac

      status="$status$icon$percentage%$state_name "
    fi
  fi

  count=$((count+1))
done

# remove whitespaces
status=$(echo "$status" | xargs)

printf '%s\n' "$status"
printf '%s\n' "$status"
