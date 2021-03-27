# Enable GPS and GPS time
I've provided an install script to get you going `sudo ./fix-gpsd.sh`.
This type of 4G modem GPS combo provides GPS sentences on /dev/ttyUSB1.
The 4G modem is accessed on ttyUSB0 and 2.

The inbox drivers in Ubuntu (20.04 in my case) should provide you with /dev/ttyUSB1 with no changes on your end.
It seems the driver qcserial provides the usb character device file we are interested in.
If you have issues just reload that driver. You may have to stop the ModemManager service to unload the driver.

My install script disables the gpsd service because it is better to start it using a udev rule.
This GPS requires you to run `echo "\$GPS_START" > /dev/ttyUSB1`.
The updated service file I have will do that for you. If you stop the gpsd service then it will also tell the
GPS to stop.
The service needs to be run after the qcserial driver creates ttyUSB1 so that's why I asked udev
to start the gpsd service once /dev/ttyUSB1 exists.

To check if the GPS is working just run `cgps -s`.

## Required packages
gpsd-clients gpsd

## GPS Time
If you would like to get time from the gps sentences you just need to install chrony.
No additional config needed besides setting up the gps.

while gpsd is running, you can check the output of `chronyc sources -v`
it should look something like this:
`
210 Number of sources = 9

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#x NMEA                          0   4   377    20   -484ms[ -484ms] +/-  100ms
^- alphyn.canonical.com          2   6   377    53   -568us[ -442us] +/-   84ms
^- chilipepper.canonical.com     2   6   377    53    +44ms[  +44ms] +/-  152ms
^- pugot.canonical.com           2   6   377    51    +27ms[  +27ms] +/-  142ms
`
As long as NMEA is in there, the time should start getting updated via GPS.