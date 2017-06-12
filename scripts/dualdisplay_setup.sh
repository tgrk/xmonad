#!/bin/bash

SCREEN_LEFT=HDMI-1
SCREEN_RIGHT=eDP1
START_DELAY=5

renice +19 $$ >/dev/null

sleep $START_DELAY

OLD_DUAL="dummy"

while [ 1 ]; do
    DUAL=$(cat /sys/class/drm/card0-HDMI-A-1/status)

    if [ "$OLD_DUAL" != "$DUAL" ]; then
        if [ "$DUAL" == "connected" ]; then
            echo 'Dual monitor setup'
            xrandr --output $SCREEN_LEFT --auto --left-of $SCREEN_RIGHT
            xrandr --output $SCREEN_RIGHT --primary
        else
            echo 'Single monitor setup'
            xrandr --auto
            #xrandr --output $SCREEN_RIGHT --primary
        fi

        OLD_DUAL="$DUAL"

        # restart trayer to ajdust it to current xmobar width
        $HOME/scripts/start_trayer.sh
    fi

    inotifywait -q -e close /sys/class/drm/card0-DP-1/status >/dev/null
done

