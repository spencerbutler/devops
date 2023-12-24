#!/bin/sh
#
# Would you rather have:
#   $10,000 or ..
#   A penny, that doubles everyday for 30 days?
# Spencer Butler <dev@tcos.us>

start=1
days=30
begin="$start"
pennies="$start"

while [ "$start" -le "$days" ]; do
	if [ "$pennies" -eq 1 ]
	then
		NOUN=Penny
	else
		NOUN=Pennies
	fi

	echo "Day: $start ${NOUN}: $pennies"

	pennies=$(( pennies * 2 ))
	start=$(( start + 1 ))
done

DOLLARS=$(echo "$pennies * .01" | bc -l)
cat << EOF

Day 1: $begin penny
Day 30: $pennies pennies \$$(numfmt --grouping "$DOLLARS")
EOF
