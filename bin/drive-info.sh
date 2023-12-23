#!/bin/sh

fstab_info="$(egrep '^U.*(parity|disk[0-9]+)' /etc/fstab)"
disks="$(echo "$fstab_info" | awk '{print $2}')"
#echo "$fstab_info"

for disk in $disks; do
	mnt_name=${disk##*/}
	[ "$disk" = "/" ] && mnt_name=$disk
	dev_name=$(df -h | grep $mnt_name | awk '{print $1}')
	smart_info=$(sudo smartctl -i $(echo $dev_name | sed -e 's/[0-9]//') | egrep '^(Device Model|Serial Number)')
	model_number=$(echo "$smart_info" | grep Model | cut -d ':' -f 2)
	serial_number=$(echo "$smart_info" | grep Serial | cut -d ':' -f 2)
	dev_name=${dev_name##*/}
	uuid=$(echo "$fstab_info" | grep $disk | awk '{print $1}')
	printf '%s\t%s\t%s\t%20s\t%s\n' $mnt_name $dev_name "$model_number" "$serial_number" "$uuid"
done
