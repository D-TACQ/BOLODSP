#!/bin/sh
# Wait until the filters are ready for another reload sequence, then
# reset the DSP system by writing to the reset register and then
# Handles Multiple callers by waiting for first call to finsh then returning

MYLOCK=/dev/shm/.reset-dsp-lock

(
	# Attempt to take lock
	if ! flock -n 9; then
		#Wait for first then return
		flock 9
		exit 0
	fi
	wait_for_filters
	set.site 14 DSP_RESET=1
	sleep 0.1
	set.site 14 DSP_RESET=0
) 9>"$MYLOCK"
