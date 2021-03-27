#!/usr/bin/env bash
# Make sure device exists
if [ -c /dev/ttyUSB1 ]; then
  # Tell gps to stop outputing
  echo "\$GPS_STOP" > /dev/ttyUSB1
fi
