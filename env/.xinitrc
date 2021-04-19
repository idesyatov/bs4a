#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
#setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"

xrdb ~/.Xresources/Default
xrandr --auto
exec i3
