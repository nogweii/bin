#!/bin/sh

# Open DMenu with each item, or if the user doesn't choose a song, output ';;;'
song_choice=`(mpc playlist | dmenu -i -p 'song name') || echo ";;;"`

# List all the songs, prepend a number then a semicolon
# Then search for the song the user choose earlier, and output it's number
song_number=`mpc playlist | nl -s ';' | sed -n "s@^ *\([0-9]\+\);$song_choice@\1@p"`

# Play that position in the playlist
if [ ! -z "$song_number" ] ; then
    mpc play $song_number
fi
