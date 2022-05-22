#!/usr/bin/sh

# Play boot chime
if type gst-play-1.0 &>/dev/null; then
	gst-play-1.0 -q $1
	exit 0
fi
