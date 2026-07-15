#!/bin/sh
# Wait until the filters are ready for another reload sequence, then
# reset the DSP system by writing to the reset register and then
# Handles Multiple callers by waiting for first call to finish then returning

MYLOCK=/dev/shm/.reset-dsp-lock
CALLER_PID=$PPID
CALLER_COMM=$(cat /proc/$CALLER_PID/comm 2>/dev/null || echo unknown)

echo "[reset.dsp] attempt - $CALLER_COMM($CALLER_PID)" > /dev/kmsg

(
	# Attempt to take lock
	if ! flock -n 9; then
		echo "[reset.dsp] in use, wait for complete - $CALLER_COMM($CALLER_PID)" > /dev/kmsg
		flock 9
		echo "[reset.dsp] wait done, skip reset - $CALLER_COMM($CALLER_PID)" > /dev/kmsg
		exit 0
	fi
	wait_for_filters
	set.site 14 DSP_RESET=1
	sleep 0.1
	set.site 14 DSP_RESET=0
	echo "[reset.dsp] reset complete - $CALLER_COMM($CALLER_PID)" > /dev/kmsg
) 9>"$MYLOCK"
