#!/bin/bash
# Purpose: a script to permanently set
# terminal window, size
APP_CLASS="gnome-terminal.Gnome-terminal"

while [ 1 ]; do
  WIN_ID=$(printf %x $(xdotool getactivewindow))
  WM_CLASS=$(wmctrl -lx | awk -v search=$WIN_ID '{ if($1~search) print $3 }')
  WMCTRL_ID=$( wmctrl -lx | awk -v search2=$WIN_ID '$0~search2 {print $1}' )
    if [ $WM_CLASS = $APP_CLASS ]; then
           wmctrl -i -r $WMCTRL_ID -e 0,0,0,650,650 
    fi
sleep 0.25
done