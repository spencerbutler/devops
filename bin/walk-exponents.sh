#!/usr/bin/env bash
#
# Walk through exponents.
# Spencer Butler <dev@tcos.us>

NUM="${1:-2}"
POWER="${2:-10}"

printf_posix() {
    # https://www.linuxquestions.org/questions/programming-9/format-numbers-using-bash-672031/#post4269148
    # If `locale` isn't properly set, `printf` will not work.
    _printf_posix_NUM="$1"

    echo "$_printf_posix_NUM"  | \
    sed -r '
      :L
      s=([0-9]+)([0-9]{3})=\1,\2=
      t L'
}

get_result() {
    _get_result_NUM="${1:-$NUM}"
    _get_result_POWER="${2:-$POWER}"
    _get_result_ECHO="${3:-""}"

    if [ "$_get_result_ECHO" = yes ]
    then
        echo $(( _get_result_NUM ** _get_result_POWER ))
    else
        printf_posix $(( _get_result_NUM ** _get_result_POWER ))
    fi
}

echo "Walk the exponents:"
START=$(( POWER - (POWER - 1) ))

while [ "$START" -le "$POWER" ]
do
    FIGURES=$(wc -c < <(echo -n $(( NUM ** START))))
    RESULT_ECHO=$(get_result "$NUM" "$START" 'yes')
    RESULT=$(get_result "$NUM" "$START")

    if [ "$RESULT_ECHO" -gt 0 ]
    then
        echo "${NUM}^${START} = $RESULT_ECHO ($RESULT) - $FIGURES figures."
        FINAL_RESULT=$(get_result)
    else
        echo "${NUM}^${START} = Too large to calculate on this platform."
        FINAL_RESULT=$(get_result "$NUM" $(( START - 1 )))
        break
    fi
    (( START++ ))
done

echo "Result: $FINAL_RESULT"