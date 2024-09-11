#!/bin/bash

#Get the argument
fir_argument=$1

# Get the current brightness level
brightness=$(xrandr --current --verbose | grep DisplayPort-2 -A5 | grep -o -P '(?<=Brightness: ).*')

# Decrease/increse the brightness by 5%

if [ "$fir_argument" = "increase" ]; then
  new_brightness=$(echo "$brightness + 0.05" | bc)
else
  new_brightness=$(echo "$brightness - 0.05" | bc)
fi



# Check if the new brightness level is above 1
if [ "$(echo "$new_brightness > 1" | bc)" -eq 1 ]; then
  new_brightness=1
fi

# Check if the new brightness level is below 0
if [ "$(echo "$new_brightness < 0" | bc)" -eq 1 ]; then
  new_brightness=0
fi

# Set the new brightness level
xrandr --output DP-2 --brightness $new_brightness
xrandr --output DP-5 --brightness $new_brightness
