#!/usr/bin/env bash
# SessionStart hook: check for fu2 upgrades (silent, rate-limited to once per
# 24h), auto-pull if available, and inject a one-line notice into Claude's
# context so the user sees "fu2 upgraded to vX.Y.Z" on their first turn.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Consume stdin from Claude Code (JSON session data we don't need)
cat >/dev/null 2>&1 || true

LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/fu2.log"
mkdir -p "$LOG_DIR"
log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] session-start $*" >> "$LOG_FILE"; }

check_out=$("$PROJECT_ROOT/bin/fu2-update-check" 2>/dev/null || true)

if [[ "$check_out" == UPGRADE_AVAILABLE* ]]; then
  log "upgrade available: $check_out"
  upgrade_out=$("$PROJECT_ROOT/bin/fu2-upgrade" 2>&1 || true)
  log "upgrade result: $upgrade_out"
  # Inject a notification into Claude's first-turn context
  if [[ "$upgrade_out" == fu2:\ upgraded* ]]; then
    jq -n --arg msg "[fu2 auto-upgrade] $upgrade_out" '{
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext: $msg
      }
    }'
  fi
elif [[ "$check_out" == JUST_UPGRADED* ]]; then
  log "post-upgrade notice: $check_out"
  jq -n --arg msg "[fu2] $check_out — config preserved" '{
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: $msg
    }
  }'
fi

exit 0
