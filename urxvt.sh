#!/bin/sh

# Simple script, attempts to open a new urxvtc connection, but failing that,
# starts the daemon and tries again. It also loops, which could be dangerous
# if the daemon never starts. (infinitely spawning itself until it does).

# The options to pass to urxvtd
DEFAULT_OPTIONS="-o -f"

urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd $DEFAULT_OPTIONS &
    urxvtc "$@"
fi
