#!/bin/bash

xrdb -merge .Xresources

#function start_app() {
#  local command = $0
#  if [ -x $command] ; then
#   exec $command &
#  else
#   echo "Unable to start command - $command"
#  fi
#}

# start some gnome stuph
gnome-settings-daemon &
/usr/lib/gnome-session/helpers/gnome-settings-daemon-helper &

syndaemon -d -t &

# set black background color
xsetroot -solid "#000000"

# start notifiation area
trayer --edge top --align right --SetDockType true --SetPartialStrut true --padding 10 \
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

# network management applet
if [ -x /usr/bin/nm-applet ] ; then
   /usr/bin/nm-applet --sm-disable &
fi

# volume applet
if [ -x /usr/bin/gnome-sound-applet ] ; then
   /usr/bin/gnome-sound-applet &
fi

exec xmonad
#exec ck-launch-session xmonad

