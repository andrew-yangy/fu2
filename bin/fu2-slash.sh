#!/usr/bin/env bash
# /fu2 slash command dispatcher. One line of output per branch.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG="$PROJECT_ROOT/config.yaml"

# shellcheck source=../lib/presets.sh
source "$PROJECT_ROOT/lib/presets.sh"

read_dim() {
  local key="$1"
  [ -f "$CONFIG" ] || { echo ""; return; }
  awk -v k="$key:" '
    $0 !~ /^[[:space:]]*#/ {
      sub(/#.*/, ""); gsub(/[[:space:]]+$/, "")
      if ($1 == k) { print $2; exit }
    }
  ' "$CONFIG"
}

current_preset() {
  local h p s pf cr key row
  h=$(read_dim harshness); p=$(read_dim profanity); s=$(read_dim sarcasm)
  pf=$(read_dim pushback_frequency); cr=$(read_dim critic_rigor)
  if [ -z "$h$p$s$pf$cr" ] || [ -z "$h" ] || [ -z "$p" ] || [ -z "$s" ] || [ -z "$pf" ] || [ -z "$cr" ]; then
    echo "unknown"; return
  fi
  key="$h $p $s $pf $cr"
  for row in "${PRESETS[@]}"; do
    _parse_row "$row"
    [ "$_VALS" = "$key" ] && { echo "$_NAME"; return; }
  done
  echo "custom"
}

# ANSI colors — emit unconditionally, Claude Code renders them.
BOLD=$'\033[1m'; DIM=$'\033[2m'
GRN=$'\033[32m'; YLW=$'\033[33m'; MAG=$'\033[35m'; CYN=$'\033[36m'
RST=$'\033[0m'

arg="${1:-}"
arg=$(echo "$arg" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

# No arg → report current (colored by intensity, current bold)
if [ -z "$arg" ]; then
  cur=$(current_preset)
  cur_col=$(color_for_preset "$cur")
  printf '%scurrent:%s %s%s%s%s  %s(options:%s %s%s)%s\n' \
    "$DIM" "$RST" \
    "$BOLD" "$cur_col" "$cur" "$RST" \
    "$DIM" "$RST" \
    "$(valid_presets_colored "$cur")" \
    "$DIM" "$RST"
  exit 0
fi

# Numeric arg (digits only) → resolve to name.
if [[ "$arg" =~ ^-?[0-9]+$ ]]; then
  if [[ "$arg" =~ ^- ]]; then
    printf '%sunknown preset number:%s %s%s%s %s(options: 1-%d)%s\n' \
      "$YLW" "$RST" "$BOLD" "$arg" "$RST" "$DIM" "${#PRESETS[@]}" "$RST"
    exit 2
  fi
  name=$(preset_by_index "$arg")
  if [ -z "$name" ]; then
    printf '%sunknown preset number:%s %s%s%s %s(options: 1-%d)%s\n' \
      "$YLW" "$RST" "$BOLD" "$arg" "$RST" "$DIM" "${#PRESETS[@]}" "$RST"
    exit 2
  fi
  arg="$name"
fi

# Name arg → validate, then apply
vals=$(preset_values "$arg")
if [ -z "$vals" ]; then
  printf '%sunknown preset:%s %s%s%s %s(options:%s %s%s)%s\n' \
    "$YLW" "$RST" "$BOLD" "$arg" "$RST" \
    "$DIM" "$RST" \
    "$(valid_presets_colored)" \
    "$DIM" "$RST"
  exit 2
fi

exec bash "$SCRIPT_DIR/apply-preset.sh" "$arg"
