#!/usr/bin/env bash
# paste!
# Spencer Butler <spencerb honeycomb.net>

if [ ! $(type -p jq) ] || [ ! $(type -p curl) ]; then
  echo "jq and curl are required to run this script."
  echo "[pkg install jq curl] [apt install jq curl] [yum install jq curl]"
  exit
fi

host=p.libren.ms
host_url="https://${host}"
api_create='/api/create'
api_get_paste='/api/paste'  # [pasteid]
api_random='/api/random'
api_recent='/api/recent'
api_trending='/api/trending'
api_langs='/api/langs'

api_check="$(curl -s ${host_url}${api_langs} | jq '.text' 2>/dev/null)"
if [ "$api_check" != '"Plain Text"' ]; then
  api_err="$(curl -sD - -o /dev/null ${host_url}${api_langs} | head -n1)"
  echo -e "Could not connect to ${host_url}${api_langs}, the server responded with\n${api_err}"
  exit
fi

usage() {
  echo -e "USAGE: 
  $(basename $0) [-o (read from STDIN)] [-s fqdn.host.name (no proto)] [-t title] [-n name] [-p private (bool)] [-l lang] [-e expire (min)|burn] [-p pasteid]" file
  echo "All arguments are optional. A file or STDOUT is all that is required."
  echo -e "\tfrom STDIN:\techo foo | $(basename $0) -o"
  echo -e "\twith file:\t$(basename $0) file.txt"
  echo -e "\twith options:\t$(basename $0) -l text -t 'my title' -n 'my name' -e burn -s p.libren.ms file.txt"
  if [ -n "$langerr" ]; then
    echo -e "\nlang \"${curlopts[lang]}\" is not known to us.\n${langerr}"
    echo -e "The API at: ${host_url}${api_langs}\nreports the following available languages:\n"
    echo "$(curl -s ${host_url}${api_langs} | jq --join-output '.| @sh \"\(.|keys)\"')"
  fi
  exit
}

if [ "$#" -lt 1 ]; then
  usage
fi


# default api data options
declare -A curlopts
# snipurl is undocumented and just needs to be set (server must have shorturls enabled)
curlopts[snipurl]=true
curlopts[name]="$(hostname -s)"
curlopts[title]="$USER says..."
curlopts[private]=0
curlopts[lang]=autoit
curlopts[expire]=30       # minutes or burn
curlopts[text]=''
curlopts[reply]=''        # requires pasteid
curlopts[pasteid]=''      # /pasteid suffix for future use

snipin() {
  curl -s "${curl_opts[@]}" --data-urlencode text@"$file" "$api_url"
}
snipout() {
  curl -s "${curl_opts[@]}" --data-urlencode text@- "$api_url"
}

while getopts 's:ot:n:x:l:e:p:h' dopt; do
  case "$dopt" in
    s)
      host="$OPTARG"
      ;;
    o)
      stdout=true
      ;;
    t)
      curlopts[title]="$OPTARG"
      ;;
    n)
      curlopts[name]="$OPTARG"
      ;;
    x)
      curlopts[private]="$OPTARG"
      ;;
    l)
      good_lang="$(curl -s ${host_url}${api_langs} | jq --raw-output ".\"${OPTARG}\"")"
      if [[ "$good_lang" == null ]]; then
        curlopts[lang]="$OPTARG"
        langerr="The server responded \"$good_lang\" to your requested \"$OPTARG\" language."
      else
        curlopts[lang]="$OPTARG"
      fi
      ;;
    e)
      curlopts[expire]="$OPTARG"
      ;;
    p)
      curlopts[pasteid]="$OPTARG"
      ;;
    ?)
      usage
      ;;
  esac
done
shift "$(($OPTIND -1))"
# we only want the file after getopts, any args after that are lost
file="$1"

# prepare all the options to send to curl
declare -a curl_opts
for copt in "${!curlopts[@]}"; do
  if [ -n "${curlopts[$copt]}" ]; then
    curl_opts+=(-d "$copt"="${curlopts[$copt]}" )
  fi
done

# we set this here so we can change the api endpoint
api="${api:-"$api_create"}"
api_url="https://${host}${api}"

# if there is not lang error, decide if we are in or out and run
if [ -n "$stdout" ] && [ ! "$langerr" ]; then
  snipout
elif [ -z "$stdout" ] && [ ! "$langerr" ]; then
  snipin
else
  usage
fi
