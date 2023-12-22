#!/usr/bin/env bash
# 
# Automagically try to resize a recently changed drive.
# `bash` is needed for the variable expansion.
# Spencer Butler <dev@tcos.us>

CHANGED=$(sudo dmesg | grep -Eo '[a-z]+: detected capacity change from [0-9]+ to [0-9]+' | tail -n 1)
CHANGED_DRIVE=$(echo "$CHANGED" | cut -d ' ' -f 1 | tr -d ':')
CHANGED_SIZE=$(echo "$CHANGED" | cut -d ' ' -f 8)
CHANGED_SIZE_LEN=${#CHANGED_SIZE}
CHANGED_SIZE_MATCH=$(echo "$CHANGED_SIZE" | cut -b 0-$((CHANGED_SIZE_LEN-3)))

CHANGED_PATH=$(sudo fdisk -l | grep -E "^/dev/${CHANGED_DRIVE}.*${CHANGED_SIZE_MATCH}" | cut -d ' ' -f 1)
CHANGED_PARTS=( "${CHANGED_PATH%[0-9]}" "$(echo "$CHANGED_PATH" | grep -Eo '[0-9]+$')" )

GROWPART=$(command -v growpart); [ -z "$GROWPART" ] && { echo "'growpart' command not found."; exit 1; }
RESIZEFS=$(command -v resize2fs); [ -z "$RESIZEFS" ] && { echo "'resize2fs' command not found."; exit 1; }


debug_output() {
    echo "\"$CHANGED_PATH\" doesn't look right, you should have a look with your eyes."
    echo
    echo ===== DEBUG =====
    echo GROWPART="$GROWPART"
    echo RESIZEFS="$RESIZEFS"
    echo
    echo CHANGED="$CHANGED"
    echo CHANGED_PATH="$CHANGED_PATH"
    echo CHANGED_DRIVE="$CHANGED_DRIVE"
    echo CHANGED_SIZE_LEN="$CHANGED_SIZE_LEN"
    echo CHANGED_SIZE="$CHANGED_SIZE"
    echo CHANGED_SIZE_MATCH="$CHANGED_SIZE_MATCH"
    echo CHANGED_PARTS="${CHANGED_PARTS[*]}"
}


[ "$1" = --debug ] && debug_output && exit 0

if echo "$CHANGED_PATH" | grep -Eq '^/'
then
    sudo "$GROWPART" "${CHANGED_PARTS[0]}" "${CHANGED_PARTS[1]}" && sudo "$RESIZEFS" "$CHANGED_PATH"
else
    debug_output
fi
