# CFS Fork of BOLODSP

Contains changes made to support CFS's usage of the BOLODSP package and DTACQ BOLO8 units.

See relevant confluence page: https://cfsenergy.atlassian.net/wiki/spaces/SPARC/pages/3660153059/Kevin+s+DTACQ+BOLO8+User+s+Guide

## Usage intructions

To generate a new package from this repo, we simply tar up the contents of the `usr` directory and `scp` it over to the DTACQ unit of interest.

We should follow the package naming convention outlined by DTACQ on pg 39 of the [4G User's Guide](https://www.d-tacq.com/resources/d-tacq-4G-acq4xx-UserGuide-r42.pdf), namely:

> SEQ-NAME-REV.tgz  
> Where SEQ is a two-digit number that indicates the position in the unpacking sequence (starting from zero). <br>
> NAME is the unique package name. <br>
> REV is a YYMMDDhhmm revision code

So, for example:
```
$ tar -czf 35-bolodsp-2411131817.tgz usr/
```

Then `scp` this package into the optional packages directory onboard the DTACQ of interest:
```
scp 35-bolodsp-2411131817.tgz root@<DTACQ_IP_ADDR>:/mnt/packages.opt/
```

Finally, `ssh` onto the dtacq, and copy this package into the proper `packages` directory, and reboot:
```
$ ssh root@<DTACQ_IP_ADDR>
$ rm /mnt/packages/<OLD_PACKAGE_VERSION>.tgz
$ cp /mnt/packages.opt/35-bolodsp-2411131817.tgz /mnt/packages
$ sync; sync; reboot
```

## Package version notes

### 35-bolodsp-2510281805.tgz

Implements a knob for getting calibration results:

- get.site 14 CAL:SENS ALL
- get.site 14 CAL:TAU ALL
- get.site 14 CAL:QOFF ALL
- get.site 14 CAL:IOFF ALL

Ref: [SW-7191: Determine Success/Failure of Calibration Procedure](https://cfsenergy.atlassian.net/browse/SW-7191)

### 35-bolodsp-2512101102.tgz

Comment out "acq400_teardown" from the run0 script, since it is not necessary to run and causes occasional failures of run0.

Ref: [SW-7316: DTACQ run0 command sometimes hangs in nightly runs](https://cfsenergy.atlassian.net/browse/SW-7316)

# BOLODSP:

DSP automation routines for BOLO8.
All math courtesy of Jack Lovell.
Test and customer support: Sean Alsop  info@d-tacq.com

BOLODSP provides "calibration as a service", connect to port 0xb010 to run a
calibration.

Recommended Procedure: 
Use HAPI: 
git pull https://github.com/D-TACQ/acq400_hapi
cd acq400_hapi; export PYTHONPATH=$PWD
cd user_apps/special

Calibrate:
python bolo8_cal_cap_loop.py --cal=1 --cap=0 --shots=1 acq2106_059

Capture:
python bolo8_cal_cap_loop.py --cal=0 --cap=1 ---shots=1 acq2106_059

Use cs-studio to view data:
https://github.com/D-TACQ/ACQ400CSS
Run BOLO8_LAUNCHER.opi, view BOLO FUNCTIONAL DATA directly


For explanation of BOLO8, see
https://github.com/jacklovell/bolodsp-doc/releases

calibfit math routine:
now completely replaced by calibfit.py

