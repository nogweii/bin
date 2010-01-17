#!/bin/sh

. /etc/rc.conf
. /etc/rc.d/functions

stat_busy 'Starting recoll indexing daemon...'

recollindex -m

stat_done
 
# Dunno why I did this, but it's fun.
#
# stat_busy & stat_done are from the service scripts in /etc/rc.d/
#
# Will have to make sure if that the API ever changes, I update this program as
# well. Can't go having an error filled application, can I?
