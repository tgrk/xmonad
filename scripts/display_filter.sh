#!/bin/sh

if [ $# -eq 0 ] || [ $1 -eq 0 ]
then
   redshift -o -t 3700:3700 -l 0.0:0.0
else
  redshift -x
fi
