#!/bin/sh

# similar to Firefox, thunderbird doesn't like libtrash
export LD_PRELOAD=""
exec thunderbird $@
