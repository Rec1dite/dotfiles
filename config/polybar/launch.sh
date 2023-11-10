#!/bin/bash

# See [https://github.com/polybar/polybar/wiki#launching-the-bar-in-your-wms-bootstrap-routine]

# Kill any existing polybar instances
#polybar-msg cmd quit
killall -q polybar	# nuclear option

echo "---" | tee -a /tmp/polybarMain.log
polybar main 2>&1 | tee -a /tmp/polybarMain.log & disown

echo "Polybar launched"
