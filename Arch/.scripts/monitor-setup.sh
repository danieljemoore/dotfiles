#!/bin/bash

# Terminate any running Polybar instances
killall -q polybar

# Detect connected monitors
if xrandr | grep "DP-5 connected" && xrandr | grep "DP-2 connected"; then
    # Dual monitor setup
    #xrandr --output DP-5 --auto --output DP-2 --auto --right-of HDMI1
    # Set workspaces for each monitor
    bspc monitor DP-5 -d I II III IV V
    bspc monitor DP-2 -d VI VII VIII IX X
    # Launch Polybar on both monitors
    polybar mybar &
    polybar mybar_two &
else
    # Single monitor setup
    xrandr --output HDMI-0 --auto --output DP1 --off
    bspc monitor HDMI-0 -d I II III IV V VI VII VIII IX X

    # Launch Polybar only on the main monitor
    MONITOR=HDMI-0 polybar mybarLarge &
fi

