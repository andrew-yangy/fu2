#!/usr/bin/env bash
# Shared preset table — single source of truth.
# Sourced by bin/fu2-slash.sh, bin/apply-preset.sh.
#
# Row format: "name | h p s pf cr"

# Ordered low-intensity → high-intensity so the color gradient reads clean
# (green → yellow → magenta → red). Numbers for /fu2 <N> follow this order.
PRESETS=(
  "chansey    | 1 1 1 1 3"     # sum 7   · green
  "pikachu    | 2 2 2 3 4"     # sum 13  · yellow
  "alakazam   | 2 1 3 4 5"     # sum 15  · yellow
  "snorlax    | 3 2 3 2 5"     # sum 15  · yellow
  "ditto      | 3 3 3 3 3"     # sum 15  · yellow
  "mewtwo     | 4 1 3 5 5"     # sum 18  · magenta
  "machamp    | 5 2 2 5 5"     # sum 19  · magenta
  "mimikyu    | 3 3 5 3 5"     # sum 19  · magenta
  "meowth     | 4 3 4 4 5"     # sum 20  · magenta
  "charmander | 4 4 4 5 4"     # sum 21  · magenta
  "gengar     | 5 5 4 5 5"     # sum 24  · red
  "gyarados   | 5 5 5 5 5"     # sum 25  · red
)

# Parse "name | v1 v2 v3 v4 v5" → sets _NAME and _VALS.
# Uses bash parameter expansion — no awk fork.
_parse_row() {
  local row="$1" name="${1%%|*}" vals="${1#*|}"
  # Trim surrounding whitespace
  name="${name#"${name%%[![:space:]]*}"}"; name="${name%"${name##*[![:space:]]}"}"
  vals="${vals#"${vals%%[![:space:]]*}"}"; vals="${vals%"${vals##*[![:space:]]}"}"
  _NAME="$name"
  _VALS="$vals"
}

preset_values() {
  local row
  for row in "${PRESETS[@]}"; do
    _parse_row "$row"
    [ "$_NAME" = "$1" ] && { echo "$_VALS"; return; }
  done
  echo ""
}

preset_by_index() {
  local idx="$1"
  # Force base-10 so /fu2 08 or /fu2 09 don't trip octal parsing.
  idx=$((10#${idx}))
  if [ "$idx" -ge 1 ] && [ "$idx" -le "${#PRESETS[@]}" ]; then
    _parse_row "${PRESETS[$((idx - 1))]}"
    echo "$_NAME"
  else
    echo ""
  fi
}

valid_presets() {
  local out="" row
  for row in "${PRESETS[@]}"; do
    _parse_row "$row"
    out+="$_NAME "
  done
  echo "${out% }"
}

# Return the ANSI color for a preset, keyed off avg intensity of its 5 dims:
#   1-2 green · 3 yellow · 4 magenta · 5 red
color_for_preset() {
  local vals h p s pf cr avg
  vals=$(preset_values "$1")
  [ -z "$vals" ] && { echo $'\033[36m'; return; }  # cyan fallback
  read -r h p s pf cr <<< "$vals"
  avg=$(( (h + p + s + pf + cr + 2) / 5 ))
  case "$avg" in
    1|2) echo $'\033[32m' ;;  # green  — gentle
    3)   echo $'\033[33m' ;;  # yellow — mid
    4)   echo $'\033[35m' ;;  # magenta — harsh
    5)   echo $'\033[31m' ;;  # red    — max
    *)   echo $'\033[36m' ;;  # cyan fallback
  esac
}

# Inline-colored list for status display. Current preset gets bold + its color;
# others get regular weight + their own color. Color reflects personality, not
# a fixed "cyan = other".
valid_presets_colored() {
  local current="${1:-}" out="" row BOLD=$'\033[1m' RST=$'\033[0m' col
  for row in "${PRESETS[@]}"; do
    _parse_row "$row"
    col=$(color_for_preset "$_NAME")
    if [ "$_NAME" = "$current" ]; then
      out+="${BOLD}${col}${_NAME}${RST} "
    else
      out+="${col}${_NAME}${RST} "
    fi
  done
  echo "${out% }"
}
