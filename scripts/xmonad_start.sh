#!/bin/bash

xrdb -merge .Xresources

# calibrate colors for Macbook AIR
#xcalib colorprofile.icc

# start some gnome stuph
gnome-settings-daemon &
/usr/lib/gnome-session/helpers/gnome-settings-daemon-helper &
gnome-sound-applet &
/usr/lib/vino/vino-server --sm-disable &

syndaemon -d -t &

# set black background color
xsetroot -solid "#000000"

# start notifiation area
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand false --widthtype request --transparent true --tint 0x000000 --height 17 &

# This must be started before seahorse-daemon.
eval $(gnome-keyring-daemon)
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID

# This is all the stuff I found in "Startup Applications".
/usr/lib/gnome-session/helpers/at-spi-registryd-wrapper &
sh -c 'test -e /var/cache/jockey/check || exec jockey-gtk --check 60' &
sh -c "sleep 1 && gnome-power-manager" &

seahorse-daemon &

# initialize instant messangers
skype & pidgin &

touchpad-indicator &

# clipboard history
parcellite &

# set background
#/usr/bin/feh --bg-fill "/home/wiso/Pictures/bender.jpg" &

# start network manager
if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi

exec xmonad
#exec ck-launch-session xmonad

