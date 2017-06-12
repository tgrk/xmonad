#!/bin/bash
#!/bin/bash

cd ~/Pictures/wallpapers/black

files=()
for i in *.jpg *.jpeg *.png; do
  [[ -f $i ]] && files+=("$i")
done
range=${#files[@]}

((range)) && feh --bg-scale "${files[RANDOM % range]}"
