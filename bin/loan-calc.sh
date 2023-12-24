#!/usr/bin/env bash
#
# A simple loan calculator.
# TODO(spencer) verify these calculations.
# Spencer Butler <dev@tcos.us>

if ! DATE=$(date --version 2>&1)
then
  echo "Date from GNU coreutils is required for this script."
  exit 1
elif [[ ! "$DATE" =~ GNU ]]
then
  echo "Date from GNU coreutils is required for this script."
  exit 1
fi

year=365
cycle=12
bill=$(( year / cycle ))
days=0
month=$(date +%B\ %Y) 
month_count=0

cur_bal=${cur_bal:-179000}
start_bal=$cur_bal
payment=${payment:-1500}
rate=${rate:-4.625}

get_help() {
  cat << EOF
Defaults to 12 billing cycles in a 365 day period.
Default settings:
  -b Current Balance ($cur_bal)
  -y Number of Days in the year ($year)
  -c Number of Cycles per Year ($cycle)
  -p Cycle Payment ($payment)
  -r Interest Rate ($rate)
EOF
    exit 0
}

apply_payment() {
awk "BEGIN { 
        printf \"%8.2f\", 
            (${cur_bal} + (((${rate}/${year}*${bill}) * ${cur_bal})/100))-${payment} 
    }"
}

get_interest() {
awk "BEGIN {
        printf \"%8.2f\",
            ((${rate}/${year}*${bill}) * ${cur_bal})/100
     }"
}

get_diff() {
    old_val=${old_val:-$1}
    cur_val=${cur_val:-$2}
    func=${3:--}
awk "BEGIN { 
        printf \"%'8.2f\",
            ${old_val} $func ${cur_val} 
    }"
}

while getopts 'y:c:b:p:r:h' dopt
do
  case "$dopt" in
    y)
      year="$OPTARG"
      ;;
    c)
      cycle="$OPTARG"
      ;;
    b)
      cur_bal="$OPTARG"
      start_bal="$OPTARG"
      ;;
    p)
      payment="$OPTARG"
      ;;
    r)
      rate="$OPTARG"
      ;;
    *)
      get_help
      ;;
  esac
done

while [ "${cur_bal%\.*}" -gt 0 ]
do
    cur_bal=$(apply_payment)
    old_bal=$start_bal
    cur_diff=$(get_diff "$old_bal" "$cur_bal")
    
    days=$(( bill + days ))
    (( month_count++ )) || true
    interest=$(get_interest)
    interest_total+="${interest}+"
    echo -e "$month:\tBalance: $cur_bal\tDiff: $cur_diff\tInterest: $interest\tInterest Total: $(echo "${interest_total%+}" | bc -l)"
    month=$(date +%B\ %Y -d "$days days")
done

printf "%s %'.2f\n" 'Staring Balance' "$start_bal"
echo Total Interest "$(get_diff "${interest_total%+}" 0 +)"
echo Total Cost of Loan "$(get_diff "$start_bal" "${interest_total%+}" +)"
echo Total Number of Months $month_count
echo cur "$cur_bal" pay "$payment" rate "$rate"
