#!/usr/bin/sh

# Play boot chime (Credit: Wu, N)
if type gst-play-1.0 &>/dev/null; then
	gst-play-1.0 -q ../../../src/chimes/chime.flac;
	exit 0
fi
