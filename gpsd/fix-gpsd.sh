#!/usr/bin/env bash
if [ $(id -u) -ne 0 ]; then
  echo "ERROR runme as root/sudo"
  exit -1
fi

# fix for: ERROR: SER: device open of /dev/ttyUSB1 failed: No such file or directory
if [ -f /dev/ttyUSB1 ]; then
  echo "INFO: deleting broken /dev/ttyUSB1, it is a file for some reason"
  rm /dev/ttyUSB1
fi

systemctl stop ModemManager
systemctl stop gpsd
modprobe -r qcserial
modprobe qcserial
sleep 5

if [ ! -c /dev/ttyUSB1 ]; then
  echo "ERROR: could not fix GPS."
  exit -1
fi

systemctl start gpsd
systemctl start ModemManager

echo "Fixed GPS functionality. Check cgps to confirm."
echo "You may need to wait ~30 seconds for GPS unit to warm up again."
