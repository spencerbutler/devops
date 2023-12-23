#!/usr/bin/env bash

n=$(echo {0..9})
a=$(echo {a..f})
hex="$n $a"

# to and from and stuff 
# *note the doubles around the singles around the unicode
# it works as long you have " and ', order doesn't seem to matter
# printf '%x\n' "'⏏'"
# 23cf
# printf '\u23cf\n'
# ⏏
declare -A U
# from man printf
# \uHHHH Unicode (ISO/IEC 10646) character with hex value HHHH (4 digits)
4dhex() {
for w in $hex; do
    for x in $hex; do
        for y in $hex; do
            for z in $hex; do
                #printf "%s%s%s%s=\U$w$x$y$z   \n" "$w" "$x" "$y" "$z"
                #U[$w$x$y$z]=$(printf "%s%s%s%s=\U$w$x$y$z   \n" "$w" "$x" "$y" "$z")
                printf "\U$w$x$y$z   %s%s%s%s\n" "$w" "$x" "$y" "$z"
                #echo ${U[$w$x$y$z]}
            done
        done
    done
done
}
4dhex
echo "U is ${#U[@]} big!"
