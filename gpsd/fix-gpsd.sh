#!/usr/bin/env bash
if [ $(id -u) -ne 0 ]; then
  echo "ERROR runme as root/sudo"
  exit -1
fi

systemctl stop gpsd
systemctl disable gpsd

cp gpsd /etc/default/

cp gpsd.service /lib/systemd/system/
cp *gps-cmd.sh /root/
cp 20-gps-modem.rules /etc/udev/rules.d/

systemctl daemon-reload
systemctl start gpsd
