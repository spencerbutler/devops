#!/usr/bin/env bash

# The return values of smartctl are defined by a bitmask. If all is well with
# the disk, the return value (exit status) of smartctl is 0 (all bits turned 
# off). If a problem occurs, or an error, potential error, or fault is 
# detected, then a non-zero status is returned. In this case, the eight 
# different bits in the return value have the following meanings for ATA 
# disks; some of these values may also be returned for SCSI disks.

declare -a bit
bit=(
'Command line did not parse.'
'Device open failed, device did not return an IDENTIFY DEVICE structure, or device is in a low-power mode (see '-n' option above).'
'Some SMART or other ATA command to the disk failed, or there was a checksum error in a SMART data structure (see '-b' option above).'
'SMART status check returned "DISK FAILING".'
'We found prefail Attributes <= threshold.'
'SMART status check returned "DISK OK" but we found that some (usage or prefail) Attributes have been <= threshold at some time in the past.'
'The device error log contains records of errors.'
'The device self-test log contains records of errors. [ATA only] Failed self-tests outdated by a newer successful extended self-test are ignored.'
)
 
dev="$1"
[ -z "$dev" ] && { echo "One dev name"; exit 1; }
sudo smartctl -x $dev

# https://www.smartmontools.org/browser/trunk/smartmontools/smartctl.8.in
val=$?; mask=1
echo "SMARTctl exit code \"$val\"" 
for i in 0 1 2 3 4 5 6 7; do
  bitval="$(((val & mask) && 1))"
	if [ "$bitval" -ne 0 ]; then
		#echo "Bit $i: $(((val & mask) && 1))"
		echo "Bit $i: ${bit[$i]}"
	fi
  mask=$((mask << 1))
done

