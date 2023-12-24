#!/bin/bash
#
# Pretty network speeds.

TARGET_LIST='(eth[0-9] )'
TARGET_LIST='(BMRU|MOPRU)'

# find interfaces to watch
targets=$(netstat -i | grep -E "$TARGET_LIST" | awk '{print $1}')
unit=${unit:-B}

delta() {
    if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$2" =~ ^[0-9]+$ ]]
    then
        printf "%d" $(( $1 - $2 ))
    fi
}

btok() {
    if [ $(( $1 / 10 )) -gt 0 ]; then
        unit=K
        echo "$1" | awk -v unit=$unit '{printf "%.3f%s", $1 / 1024, unit}'
    elif [ $(( $1 / 100 )) -gt 0 ]; then
        unit=M
        echo "$1" | awk -v unit=$unit '{printf "%.4f", $1 / 1024/1024, unit}'
    else
        unit=B
        echo "$1" | awk -v unit=$unit '{printf "%d", $1, unit}'
    fi
}

while :; do
    x=7
    for target in $targets; do
        if [ $x -ge 8 ]; then
            x=1
        fi
        tx="$(netstat -i | grep ^"$target" | awk '{print $7}')"
        rx=$(netstat -i | grep ^"$target" | awk '{print $3}')
        sleep 1
        tx2="$(netstat -i | grep ^"$target" | awk '{print $7}')"
        rx2=$(netstat -i | grep ^"$target" | awk '{print $3}')
    
        rtx=$(btok "$(delta "$tx2" "$tx")")
        rrx=$(btok "$(delta "$rx2" "$rx")")
    
        tput setab $x
        echo -e "IF: $target\t TX: ${rtx} ${unit}ps\t RX: ${rrx} ${unit}ps"
        tput sgr0
        (( x++ )) || true
    done
done
