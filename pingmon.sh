#!/usr/bin/env bash
# PingMon (Cron only version)
# Author: you

set -u -o pipefail

CONFIG_FILE="/etc/pingmon/config.env"

# โหลด config
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
else
  echo "ERROR: Config not found at $CONFIG_FILE" >&2
  exit 1
fi

# ตรวจสอบ input file
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "ERROR: Target list not found: $INPUT_FILE" >&2
  exit 1
fi

mkdir -p "$LOG_DIR"

PING_BIN="ping"
if [[ "${IPV6:-0}" -eq 1 ]]; then
  PING_BIN="ping -6"
fi

ping_one() {
  local ip="$1"
  local ip_dir="$LOG_DIR/$ip"
  mkdir -p "$ip_dir"

  local today
  today="$(date +%F)"
  local ts
  ts="$(date -Iseconds)"
  local logfile="$ip_dir/$today.log"

  local out rc=0
  out=$($PING_BIN -n -q -c "$PING_COUNT" -W "$PING_TIMEOUT" "$ip" 2>&1) || rc=$?

  local status="down" loss="100" rtt_avg=""
  if grep -qi "packet loss" <<<"$out"; then
    loss="$(sed -n 's/.* \([0-9]\+\)% packet loss.*/\1/p' <<<"$out" | head -n1)"
  fi
  if grep -qi "min/avg/max" <<<"$out"; then
    rtt_avg="$(sed -n 's/.*=\s*\([0-9.]\+\)\/\([0-9.]\+\)\/.*/\2/p' <<<"$out" | head -n1)"
  fi
  if [[ "$loss" =~ ^[0-9]+$ ]] && (( loss < 100 )); then
    status="up"
  fi

  echo "$ts,$status,$loss,${rtt_avg:-},$rc" >> "$logfile"
}

do_retention() {
  find "$LOG_DIR" -type f -name "*.log" -mtime +"$RETENTION_DAYS" -delete
  find "$LOG_DIR" -type d -empty -delete
}

mapfile -t targets < <(grep -v '^\s*#' "$INPUT_FILE" | sed '/^\s*$/d')
for ip in "${targets[@]}"; do
  ping_one "$ip" &
done
wait

do_retention