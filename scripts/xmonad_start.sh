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
 --expand false --widthtype request --transparent true --alpha 0 --tint 0x000000 --height 17 &

# This must be started before seahorse-daemon.
eval $(gnome-keyring-daemon)
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID

# This is all the stuff I found in "Startup Applications".
/usr/lib/gnome-session/helpers/at-spi-registryd-wrapper &
sh -c 'test -e /var/cache/jockey/check || exec jockey-gtk --check 60' &
sh -c "sleep 1 && gnome-power-manager" &

if [ -x /usr/bin/seahorse-daemon] ; then
   /usr/bin/seahorse-daemon &
fi

# instant messangers
if [ -x /usr/bin/skype ] ; then
   /usr/bin/skype &
fi
if [ -x /usr/bin/pidgin ] ; then
   /usr/bin/pidgin &
fi

# prevents touchpad madness while running you mouse
if [ -x /usr/bin/touchpad-indicator ] ; then
   /usr/bin/touchpad-indicator &
fi

# clipboard history
if [ -x /usr/bin/parcellite ] ; then
   /usr/bin/parcellite &
fi

# video/gaming screen sleep prevention
if [ -x /usr/bin/caffeine ] ; then
   /usr/bin/caffeine &
fi

# cpufrq indicator
if [ -x /usr/bin/indicator-cpufreq ] ; then
   /usr/bin/indicator-cpufreq &
fi

# dropbox 
if [ -x /usr/bin/dropbox ] ; then
   /usr/bin/dropbox start &
fi 

# network management applet
if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi

exec xmonad
#exec ck-launch-session xmonad

