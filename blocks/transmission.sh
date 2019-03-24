#!/usr/bin/env sh

turtle=T
turtle_color=red

while getopts l:k: opt; do
  case "$opt" in
    l) turtle="$OPTARG" ;;
    k) turtle_color="$OPTARG" ;;
    *) exit 1 ;;
  esac
done

total=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ {count++} END {print count}')
incomplete=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ && $5 != "Done" {count++} END {print count}')
downloading=$(transmission-remote -l | awk -v count=0 '$1 ~ /^[0-9]*$/ && ($9 == "Downloading" || $10 == "Downloading") {count++} END {print count}')
turtle_mode=$(transmission-remote -si |grep -c 'Enabled turtle limit')

case "$BLOCK_BUTTON" in
  1) transmission-remote -as >/dev/null 2>&1 ;;
  2) if [ "$turtle_mode" -eq 0 ]; then transmission-remote -as >/dev/null 2>&1; else transmission-remote -AS >/dev/null 2>&1; fi ;;
  3) transmission-remote -AS >/dev/null 2>&1 ;;
esac

if [ "$turtle_mode" -eq 0 ]; then
  printf "%s\n" "$total/$incomplete/$downloading"
  printf "%s\n" "$total/$incomplete/$downloading"
else
  printf "%s\n" "$total/$incomplete/$downloading <span foreground=\"$turtle_color\">$turtle</span>"
  printf "%s\n" "$total/$incomplete/$downloading <span foreground=\"$turtle_color\">$turtle</span>"
fi
