#!/usr/bin/env bash
# Make sure device exists
if [ -c /dev/ttyUSB1 ]; then
  echo "\$GPS_START" > /dev/ttyUSB1
fi
