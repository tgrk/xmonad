#!/bin/sh

if pgrep "trayer" > /dev/null
then
   killall trayer
   trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --tint 0x000000 --height 17
fi

