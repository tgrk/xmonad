#!/usr/bin/env bash

sed -i 's/GeometryWidth=.*/GeometryWidth=800/' .config/gtk-2.0/gtkfilechooser.ini
sed -i 's/GeometryHeight=.*/GeometryHeight=600/' .config/gtk-2.0/gtkfilechooser.ini
