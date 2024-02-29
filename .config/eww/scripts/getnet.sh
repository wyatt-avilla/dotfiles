#!/bin/bash

get_best_rate () {
  base=1000
  bytes=$1
  type=$2

  rate=""
  amount=""

  if ((bytes < base)); then
      rate=" B/s"
      if [[ $bytes -lt 10 ]]; then
        amount="$bytes.000"
      elif [[ $bytes -ge 10 && $bytes -lt 100 ]]; then
        amount="$bytes.00"
      elif [[ $bytes -ge 100 && $bytes -lt 1000 ]]; then
        amount="$bytes.0"
      else
        amount="$bytes"
      fi
  elif ((bytes >= base && bytes < base**2)); then
      rate="kB/s"
      amount=$(echo "scale=3; $bytes / $base" | bc)
  else
      rate="MB/s"
      amount=$(echo "scale=3; $bytes / $base / $base" | bc)
  fi

  if [[ "$type" == "incoming" ]]; then
    inc_rate="$rate"
    inc_amount="$amount"
  else
    out_rate="$rate"
    out_amount="$amount"
  fi
}

interface="eno1"
inc_file_name="/sys/class/net/${interface}/statistics/rx_bytes"
out_file_name="/sys/class/net/${interface}/statistics/tx_bytes"

inc_start=$(cat "$inc_file_name")
out_start=$(cat "$out_file_name")
sleep 1
inc_amount=$(( $(cat "$inc_file_name") - inc_start ))
out_amount=$(( $(cat "$out_file_name") - out_start ))

inc_rate=""
out_rate=""
get_best_rate "$inc_amount" "incoming"
get_best_rate "$out_amount" "outgoing"

incoming_formatted="${inc_amount:0:5} $inc_rate"
outgoing_formatted="${out_amount:0:5} $out_rate"

printf '{"incoming":"%s","outgoing":"%s"}\n' \
  "$incoming_formatted" "$outgoing_formatted"
