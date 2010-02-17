#!/bin/bash
echo "remote_notify.sh: Connected & listening to \`me' and waiting for highlighted messages..."

ssh -q me ": > .irssi/fnotify ; tail -f .irssi/fnotify " |
sed -u 's/[<@&]//g' | # Strip unsafe (for notification-daemon) chars
while read heading message; do
	/usr/bin/notify-send -u critical -i /usr/share/icons/Tango/24x24/apps/terminal.png -t 30000 -- "${heading}" "${message}";
done
