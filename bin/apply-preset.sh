#!/usr/bin/env bash
# Apply a fu2 personality preset by writing its dim scores to config.yaml.
# Usage: apply-preset.sh <preset-name>
#
# Called from the /fu2 slash command. Prints confirmation to stdout.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG="$PROJECT_ROOT/config.yaml"

# shellcheck source=../lib/presets.sh
source "$PROJECT_ROOT/lib/presets.sh"

sedi() {
  if [[ "$OSTYPE" == "darwin"* ]]; then sed -i '' "$@"; else sed -i "$@"; fi
}

preset="${1:-}"
if [ -z "$preset" ]; then
  echo "usage: /fu2 <preset>"
  echo "available: $(valid_presets)"
  exit 2
fi

vals=$(preset_values "$preset")
if [ -z "$vals" ]; then
  echo "unknown preset: $preset"
  echo "available: $(valid_presets)"
  exit 2
fi

read -r h p s pf cr <<< "$vals"
sedi -E "s/^(  harshness:) [0-9]+/\\1 $h/"            "$CONFIG"
sedi -E "s/^(  profanity:) [0-9]+/\\1 $p/"            "$CONFIG"
sedi -E "s/^(  sarcasm:) [0-9]+/\\1 $s/"              "$CONFIG"
sedi -E "s/^(  pushback_frequency:) [0-9]+/\\1 $pf/"  "$CONFIG"
sedi -E "s/^(  critic_rigor:) [0-9]+/\\1 $cr/"        "$CONFIG"

# Colored confirmation — name colored by personality intensity
BOLD=$'\033[1m'; DIM=$'\033[2m'; MAG=$'\033[35m'; RST=$'\033[0m'
PRESET_COL=$(color_for_preset "$preset")
printf '%sfu2:%s switched to %s%s%s%s  %s(%s %s %s %s %s)%s\n' \
  "$MAG$BOLD" "$RST" \
  "$BOLD" "$PRESET_COL" "$preset" "$RST" \
  "$DIM" "$h" "$p" "$s" "$pf" "$cr" "$RST"
