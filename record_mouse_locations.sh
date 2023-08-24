#!/bin/bash

# Idea taken from https://stackoverflow.com/questions/55922664/write-mouse-coordinates-and-mouse-clicks-with-timestamps-to-file

echo "# Recording mouse click locations..."

MOUSE_ID=$(xinput --list | grep -i -m 1 'mouse' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
MOUSE_ID=16  #TODO: Ask the user for an override

# trap 'sed "s/=/ = /g" .capture.tmp | awk -f extract_mouse_locations.awk - > capture' INT

# xinput test $MOUSE_ID | tee .capture.tmp

button_state_current=$(xinput --query-state $MOUSE_ID | grep 'button\['"."']=down' | sort)
x_position_current=$(xinput --query-state $MOUSE_ID | grep 'valuator\[0\]=' | awk -F= '{print $2}')
y_position_current=$(xinput --query-state $MOUSE_ID | grep 'valuator\[1\]=' | awk -F= '{print $2}')
scroll_position_current=$(xinput --query-state $MOUSE_ID | grep 'valuator\[3\]' | awk -F= '{print $2}')
while true; do
  sleep 0.005
  button_state_new=$(xinput --query-state $MOUSE_ID | grep 'button\['"."']=down' | sort)
  x_position_new=$(xinput --query-state $MOUSE_ID | grep 'valuator\[0\]=' | awk -F= '{print $2}')
  y_position_new=$(xinput --query-state $MOUSE_ID | grep 'valuator\[1\]=' | awk -F= '{print $2}')
  scroll_position_new=$(xinput --query-state $MOUSE_ID | grep 'valuator\[3\]' | awk -F= '{print $2}')
  # Detect events and record them
  click_event=$(comm -13 <(echo "$button_state_current") <(echo "$button_state_new"))
  scroll_event=$(comm -13 <(echo "$scroll_position_current") <(echo "$scroll_position_new"))
  if [[ -n "$click_event" ]]; then
    button_pressed=$(echo "$click_event" | grep -o '\[[0-9]\]' | grep -o '[0-9]')
    # Get a description for this
    # echo "Button press $button_pressed"
    # echo "- X: $x_position_new"
    # echo "- Y: $y_position_new"
    description=$(echo "" | dmenu -p "Enter description for this click: # ")
    echo "# $description"
    echo "xdotool mousemove $x_position_new $y_position_new"
    echo "xdotool click $button_pressed"
  fi
  if [[ -n "$scroll_event" ]]; then
    echo "# Scroll event"
    echo "# - X: $x_position_new"
    echo "# - Y: $y_position_new"
    echo "# - Scroll start: $scroll_position_current"
    echo "# - Scroll end: $scroll_position_new"
    # echo "xdotool mousemove $x_position_new $y_position_new"
  fi
  button_state_current="$button_state_new"
  x_position_current="$x_position_new"
  y_position_current="$y_position_new"
  scroll_position_current="$scroll_position_new"
done
