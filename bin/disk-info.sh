#!/bin/sh
#
# Smartctl disk information
# Spencer Butler <dev@tcos.us>

DISKS=$(ls /dev/[shm]d[a-z])
SMARTCTL=$(command -v smartctl)

if [ -z "$SMARTCTL" ]
then
    echo "You need smartctl (smartmontools) for this script."
    exit 1
fi
    

for DISK in $DISKS; do 
    echo "==> $DISK"
    sudo smartctl -i "$DISK" | \
        grep -E '^(Model|Device Model|User|Serial|SATA)'
    echo
done
