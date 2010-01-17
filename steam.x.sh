#!/bin/sh

echo "-------------- steam.x.sh -------------"

cd $HOME/sys/etc/SteamX

DISPLAY=:1.0

echo $(pwd)

# This is in ~/sys/etx/SteamX, not /etc/X11 !
#
# Symlinked from /etc/X11/xorg.steam to /home/colin/sys/etc/SteamX/xorg.conf
# since xinit cd's to /etc/X11
xinit ./start.sh $* -- :1 -config ./xorg.steam
