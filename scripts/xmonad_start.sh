#!/bin/bash

xrdb -merge .Xresources

# set dual screen mode
xrandr --output DP1 --auto --left-of eDP1 &
xrandr --output DP1 --primary &

# start some gnome stuph
gnome-settings-daemon &
#/usr/lib/gnome-session/helpers/gnome-settings-daemon-helper &

syndaemon -d -t &

# set black background color
xsetroot -solid "#000000"

# randomly rotate wallpapers
#/home/tgrk/scripts/random_wallpaper.sh &

# start notifiation area
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --widthtype request --transparent true --alpha 0 --tint 0x000000 --height 17 &

# This must be started before seahorse-daemon.
eval $(gnome-keyring-daemon)
#export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID

# This is all the stuff I found in "Startup Applications".
/usr/lib/gnome-session/helpers/at-spi-registryd-wrapper &
sh -c 'test -e /var/cache/jockey/check || exec jockey-gtk --check 60' &
sh -c "sleep 1 && gnome-power-manager" &

if [ -x /usr/bin/seahorse-daemon] ; then
   /usr/bin/seahorse-daemon &
fi

# style for GTK
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# network management applet
if [ -x /usr/bin/nm-applet ] ; then
   /usr/bin/nm-applet --sm-disable &
fi

# volume applet
if [ -x /usr/bin/pnmixer ] ; then
   /usr/bin/pnmixer &
fi

# power management
if [ -x /usr/bin/xfce4-power-manager ] ; then
  /usr/bin/xfce4-power-manager &
fi

# start slack
if [ -x /usr/bin/slack ] ; then
  /usr/bin/slack &
fi

# start skype
if [ -x /usr/bin/skype ] ; then
  /usr/bin/skype &
fi

exec xmonad
#exec ck-launch-session xmonad

