#!/bin/bash

SCREEN_LEFT=DP1
SCREEN_RIGHT=eDP1
START_DELAY=5

renice +19 $$ >/dev/null

sleep $START_DELAY

OLD_DUAL="dummy"

while [ 1 ]; do
    DUAL=$(cat /sys/class/drm/card0-DP-1/status)

    if [ "$OLD_DUAL" != "$DUAL" ]; then
        if [ "$DUAL" == "connected" ]; then
            echo 'Dual monitor setup'
            xrandr --output $SCREEN_LEFT --auto --left-of $SCREEN_RIGHT
            xrandr --output $SCREEN_LEFT --primary

            # reload for xmobar etc
            xmonad --restart
        else
            echo 'Single monitor setup'
            xrandr --auto
            xrandr --output $SCREEN_RIGHT --primary

            # reload for xmobar etc
            xmonad --restart
        fi

        OLD_DUAL="$DUAL"
    fi

    inotifywait -q -e close /sys/class/drm/card0-DP-1/status >/dev/null
done

