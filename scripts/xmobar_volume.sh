vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)

if [ "$vol" = "MM" ] ; then
  vol="Mute"
  COLOR='red'
else
  COLOR='green'
fi

echo "Vol: <fc=$COLOR>$vol</fc>"
