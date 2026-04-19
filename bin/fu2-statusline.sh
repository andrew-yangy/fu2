#!/usr/bin/env bash
# fu2 statusline: one colored line showing current personality + dim scores.
# Configured via ~/.claude/settings.json statusLine. Stdin receives JSON
# session data (model, cwd, etc) — we don't use it; state comes from config.yaml.

set -u

# Resolve our own location → project root → config.yaml
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG="$PROJECT_ROOT/config.yaml"

# Swallow stdin (Claude Code pipes JSON; we don't need it for now).
cat >/dev/null 2>&1 || true

# Colors (always emit — Claude Code renders ANSI in the statusline).
BOLD=$'\033[1m'; DIM=$'\033[2m'
GRN=$'\033[32m'; YLW=$'\033[33m'; RED=$'\033[31m'
MAG=$'\033[35m'; CYN=$'\033[36m'
RST=$'\033[0m'

# Read dims from config.yaml (single awk per key, exit on first match).
h=$(awk '/^  harshness:/ {print $2; exit}' "$CONFIG" 2>/dev/null)
p=$(awk '/^  profanity:/ {print $2; exit}' "$CONFIG" 2>/dev/null)
s=$(awk '/^  sarcasm:/ {print $2; exit}' "$CONFIG" 2>/dev/null)
pf=$(awk '/^  pushback_frequency:/ {print $2; exit}' "$CONFIG" 2>/dev/null)
cr=$(awk '/^  critic_rigor:/ {print $2; exit}' "$CONFIG" 2>/dev/null)
enabled=$(awk '/^inject_enabled:/ {print $2; exit}' "$CONFIG" 2>/dev/null)

# Bail softly if config is missing — don't crash the statusline.
if [ -z "${h:-}" ] || [ -z "${p:-}" ] || [ -z "${s:-}" ] || [ -z "${pf:-}" ] || [ -z "${cr:-}" ]; then
  printf '%s[fu2]%s %sconfig missing%s\n' "$MAG$BOLD" "$RST" "$DIM" "$RST"
  exit 0
fi

# Find matching preset. Keep in sync with preset_values() in setup.
preset_of() {
  case "$1" in
    "1 1 1 1 3") echo "chansey" ;;
    "2 2 2 3 4") echo "pikachu" ;;
    "2 1 3 4 5") echo "alakazam" ;;
    "4 3 4 4 5") echo "meowth" ;;
    "4 4 4 5 4") echo "charmander" ;;
    "5 2 2 5 5") echo "machamp" ;;
    "5 5 5 5 5") echo "gyarados" ;;
    "5 5 4 5 5") echo "gengar" ;;
    "3 2 3 2 5") echo "snorlax" ;;
    "4 1 3 5 5") echo "mewtwo" ;;
    "3 3 5 3 5") echo "mimikyu" ;;
    "3 3 3 3 3") echo "ditto" ;;
    *)           echo "" ;;
  esac
}

avg=$(( (h + p + s + pf + cr + 2) / 5 ))
case "$avg" in
  1|2) label_color="$GRN" ;;
  3)   label_color="$YLW" ;;
  *)   label_color="$RED" ;;
esac

pokemon=$(preset_of "$h $p $s $pf $cr")
if [ -z "$pokemon" ]; then
  # Off-preset: closest-intensity pokemon, marked "custom"
  case "$avg" in
    1) pokemon="chansey" ;;
    2) pokemon="pikachu" ;;
    3) pokemon="alakazam" ;;
    4) pokemon="meowth" ;;
    5) pokemon="gyarados" ;;
    *) pokemon="pikachu" ;;
  esac
  label="${pokemon}*"   # asterisk = tuned off-preset
else
  label="$pokemon"
fi

# Injection state — dim the output if hooks are disabled.
if [ "${enabled:-false}" = "true" ]; then
  status_icon=""
else
  status_icon="${YLW}⚠ off${RST} "
fi

# Final one-liner
printf '%s[fu2]%s %s%s%s%s%s %s·%s h%d p%d s%d pf%d cr%d %s·%s %s/fu2 <name>%s to switch\n' \
  "$MAG$BOLD" "$RST" \
  "$status_icon" \
  "$BOLD" "$label_color" "$label" "$RST" \
  "$DIM" "$RST" \
  "$h" "$p" "$s" "$pf" "$cr" \
  "$DIM" "$RST" \
  "$CYN" "$RST"
