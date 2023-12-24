#!/bin/sh
#
# Fully utilize a disk, no root reservation
# Spencer Butler <dev@tcos.us>

# https://github.com/trapexit/backup-and-recovery-howtos/blob/master/docs/backup_(mergerfs%2Ccrashplan%2Csnapraid).md#1-format-the-drives
# The -m 0 is to keep mkfs.ext4 from reserving capacity for root 
#   which means you'll be able to use as much of the disk as possible.
#
# -T largefile4 is optional but useful when you expect to have fewer large files versus many small or average size files.
#   It saves some space. Valid options for -T and what they mean are found in the fs_types section of /etc/mke2fs.conf.
#   If unsure what would be best for your setup simply leave out -T largefile4.

# We format the raw drives rather than the creating partitions for the following reasons.
#
# The partition is mostly useless to us since we plan on using the entire drive
# We no longer need to worry about MBR vs GPT
# We no longer need to worry about block alignment.
# When a 512e/4k drive is moved between a native SATA controller and a USB SATA converter there won't be partition block misalignment.
#    Often USB adapters will report 4k/4k to the OS while the drive will report 512/4k causing the OS to not be able to find the paritions
#   or filesystems. This can be fixed but no tools exist to do the procedure automatically.

DISK="$1"
NAME="$2"

if [ -n "$DISK" ]
then
    if [ -n "$NAME" ]
    then
        echo "Formatting $DISK with name ${NAME}."
        echo "We are using '-m 0' and '-T largefile4'"
        echo "options to fully utilize the disk."
        echo
        sudo mkfs.ext4 -m 0 -T largefile4 -L "$NAME" "$DISK"
    else
        echo "Please provide a NAME for the disk."
    fi
else
    echo "Provide the full path to the DISK to format, and a NAME."
fi