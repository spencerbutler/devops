#!/bin/sh
#
# A simple dos2unix script (without the dos2unix package).
# Spencer Butler <dev@tcos.us>

FILE="$1"
[ -z "$FILE" ] && { echo "Supply a file name to fix."; exit 0; }
[ -r "$FILE" ] || { echo "\"$FILE\" is not readable."; exit 1; }

TMP=$(mktemp)
tr -d '\r' < "$FILE" > "$TMP"
mv "$TMP" "$FILE"
