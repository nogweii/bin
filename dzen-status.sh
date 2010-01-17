#!/bin/zsh
#
# xmonad statusline, (c) 2007 by Robert Manea
#
 
# Configuration
DATE_FORMAT='%A, %d.%m.%Y %H:%M:%S'
WEATHER_FORECASTER=$HOME/.dzen/weather.pl
DZEN_ICONPATH=$HOME/.dzen/bitmaps/
#MAILDIR=
 
# Main loop interval in seconds
INTERVAL=1
 
# function calling intervals in seconds
DATEIVAL=1
MAILIVAL=60
CPUTEMPIVAL=1
WEATHERIVAL=1800
 
# Functions
fdate() {
    date +$DATE_FORMAT
}
 
fcputemp() {
   print -n ${(@)$(</proc/acpi/thermal_zone/THRM/temperature)[2,3]}
}
 
fmail() {
    local -A counts; local i
 
    for i in "${MAILDIR:-${HOME}/Mail}"/**/new/*
        { (( counts[${i:h:h:t}]++ )) }
    for i in ${(k)counts}
        { print -n $i: $counts[$i]' ' }
}
 
fweather() {
   $WEATHER_FORECASTER
}

curtitle() {
	print `wmctrl -l | grep $(echo "obase=16;$(xdotool getactivewindow)" | bc) | cut -d' ' -f5-`
}
 
 
# Main
 
# initialize data
DATECOUNTER=$DATEIVAL;
MAILCOUNTER=$MAILIVAL;
CPUTEMPCOUNTER=$CPUTEMPIVAL;
WEATHERCOUNTER=$WEATHERIVAL
 
while true; do
   if [ $DATECOUNTER -ge $DATEIVAL ]; then
     PDATE=$(fdate)
     DATECOUNTER=0
   fi
 
   if [ $MAILCOUNTER -ge $MAILIVAL ]; then
     TMAIL=$(fmail)
       if [ $TMAIL ]; then
         PMAIL="^fg(khaki)^i(${DZEN_ICONPATH}/mail.xpm)^p(3)${TMAIL}"
       else
         PMAIL="^fg(grey60)^i(${DZEN_ICONPATH}/envelope.xbm)"
       fi
     MAILCOUNTER=0
   fi
 
   if [ $CPUTEMPCOUNTER -ge $CPUTEMPIVAL ]; then
     PCPUTEMP=$(fcputemp)
     CPUTEMPCOUNTER=0
   fi
 
   if [ $WEATHERCOUNTER -ge $WEATHERIVAL ]; then
     PWEATHER=$(fweather)
     WEATHERCOUNTER=0
   fi
 
   # Arrange and print the status line
   print "$PWEATHER $PCPUTEMP $PMAIL ^fg(white)${PDATE}^fg()"
 
   DATECOUNTER=$((DATECOUNTER+1))
   MAILCOUNTER=$((MAILCOUNTER+1))
   CPUTEMPCOUNTER=$((CPUTEMPCOUNTER+1))
   WEATHERCOUNTER=$((WEATHERCOUNTER+1))
 
   sleep $INTERVAL
done
