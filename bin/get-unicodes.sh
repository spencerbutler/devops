#!/usr/bin/env bash
#
# Get a unicode character (or range) from ID[s]
# Spencer Butler <dev@tcos.us>

FROM="${1:-21}"
TO="${2:-$FROM}"
RANGE=$(seq "$FROM" "$TO")

for ID in $RANGE; do 
    printf "%s\t\U$ID\n" "$ID"
done

if [ "$#" -eq 0 ]
then
    echo
    echo "You can also get a range, a single ARG will return 1 value set."
    echo "$(basename "$0") FROM TO"
fi