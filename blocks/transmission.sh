#!/usr/bin/env sh

turtle=T

while getopts l: opt; do
  case "$opt" in
    l) turtle="$OPTARG" ;;
    *) exit 1 ;;
  esac
done

total=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ {count++} END {print count}')
incomplete=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ && $5 != "Done" {count++} END {print count}')
downloading=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ && ($9 == "Downloading" || $10 == "Downloading") {count++} END {print count}')
unlimited=$(transmission-remote -si | grep -c "Download speed limit: Unlimited")

case "$BLOCK_BUTTON" in
  1) transmission-remote -as >/dev/null 2>&1 ;;
  3) transmission-remote -AS >/dev/null 2>&1 ;;
esac

if [ "$unlimited" -eq 1 ]; then
  printf "%s\n" "$total/$incomplete/$downloading"
  printf "%s\n" "$total/$incomplete/$downloading"
else
  printf "%s\n" "$total/$incomplete/$downloading $turtle"
  printf "%s\n" "$total/$incomplete/$downloading $turtle"
fi
