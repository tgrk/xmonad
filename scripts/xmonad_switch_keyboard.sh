#!/bin/sh
# switch between my layouts

# If an explicit layout is provided as an argument, use it. Otherwise, select the next layout from
# the set [us, cz, de].
if [ -n "$1" ]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | awk 'END{print $2}')
    case $layout in
        us)
                setxkbmap cz
            ;;
        cz)
                setxkbmap de
            ;;
        *)
                setxkbmap us
            ;;
    esac
fi
