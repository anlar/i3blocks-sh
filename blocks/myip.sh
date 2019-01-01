#!/usr/bin/env sh

if [ -n "$BLOCK_INSTANCE" ]; then
  instance="$BLOCK_INSTANCE"
else
  instance=ip
fi

status=$(curl ifconfig.co/$instance -s)

printf '%s\n' "$status"
printf '%s\n' "$status"
