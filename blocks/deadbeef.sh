#!/usr/bin/env sh

hide_inactive=0

playing=Play
paused=Pause
stopped=Stop

while getopts a:b:c:q opt; do
	case "$opt" in
		a) playing="$OPTARG" ;;
		b) paused="$OPTARG" ;;
		c) stopped="$OPTARG" ;;
		q) hide_inactive=1 ;;
	esac
done

song="$(deadbeef.sh --nowplaying-tf "%artist% - %title%")"
isplaying="$(deadbeef.sh --nowplaying-tf "%isplaying%")"
ispaused="$(deadbeef.sh --nowplaying-tf "%ispaused%")"

if [ "$isplaying" = '1' ]; then
	status="$playing"
else
	if [ "$ispaused" = '1' ]; then
		status="$paused"
	else
		status="$stopped"
	fi
fi

case "$BLOCK_BUTTON" in
	1|4) deadbeef.sh --next ;;
	3|5) deadbeef.sh --prev ;;
	2) deadbeef.sh --play-pause ;;
esac

if [ $hide_inactive -eq 1 -a "$status" = Stopped ]; then
	exit 0
fi


printf "%s %s\n" "$status" "$song"
printf "%s\n" "$song"

