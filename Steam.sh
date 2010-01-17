#!/bin/sh

# WINE binary
CDLOADER_WINE="wine"

WINEDEBUG="-all" nice -n -8 $CDLOADER_WINE "C:/Program Files/Steam/steam.exe" -- "$@"
