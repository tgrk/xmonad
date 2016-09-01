#!/bin/bash

PWR=$(acpi -b | cut -f4 -d' ' | tr -d '%' | tr -d ',' | head -n1)

COLOR='green'
if [ $PWR -gt 0 ] ; then
  COLOR='red'
fi

if [ $PWR -gt 20 ] ; then
  COLOR='yellow'
fi

if [ $PWR -gt 60 ] ; then
  COLOR='green'
fi

if [[ $(acpi -a) == 'Adapter 0: on-line' ]] ; then
  COLOR='cadetblue'
  PWR='AC'
fi

echo "<fc=$COLOR>$PWR</fc>"
