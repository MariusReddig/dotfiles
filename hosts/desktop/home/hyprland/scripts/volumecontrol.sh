#!/usr/bin/env bash

# You can call this script like this:
# $ ./volumeControl.sh up
# $ ./volumeControl.sh down
# $ ./volumeControl.sh mute

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function send_notification {
	iconSound="audio-volume-high"
	iconMuted="audio-volume-muted"
	if [[ $(pamixer --get-mute) == "true" ]]; then
		notify-send -t 3000 -h string:x-dunst-stack-tag:volume_notif " 󰝟 Sound muted "
	else
		volume=$(pamixer --get-volume)
		# Send the notification
		notify-send -t 3000 -h string:x-dunst-stack-tag:volume_notif -h int:value:$volume "  $volume%"
	fi
}

case $1 in
up)
	# set the volume on (if it was muted)
	pamixer -u >/dev/null
	# up the volume (+ 5%)
	pamixer -i 5 >/dev/null
	send_notification
	;;
down)
	pamixer -u >/dev/null
	pamixer -d 5 >/dev/null
	send_notification
	;;
mute)
	# toggle mute
	pamixer -t >/dev/null
	send_notification
	;;
esac
