#!/usr/bin/env bash
# Stop hook: block finishing unless Claude spawned a critic subagent this turn.
# Stdin: JSON with transcript_path, stop_hook_active, session_id.
# Stdout: JSON with decision: "block" + reason if critic pass is needed, else empty.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/fu2.log"
STATE_DIR="$HOME/.claude/logs/fu2-state"
mkdir -p "$LOG_DIR" "$STATE_DIR"

# shellcheck source=../lib/personality.sh
source "$PROJECT_ROOT/lib/personality.sh"

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] stop $*" >> "$LOG_FILE"; }

HOOK_INPUT=$(cat)
SESSION=$(echo "$HOOK_INPUT" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")
TRANSCRIPT=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // ""' 2>/dev/null || echo "")
STOP_ACTIVE=$(echo "$HOOK_INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null || echo "false")

log "session=$SESSION transcript=$TRANSCRIPT stop_active=$STOP_ACTIVE"

# Safety: don't infinite-loop. Cap block count per session.
COUNTER_FILE="$STATE_DIR/$SESSION.blocks"
BLOCKS=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
if [ "$BLOCKS" -ge 2 ]; then
  log "max blocks reached ($BLOCKS) for session — allowing stop"
  exit 0
fi

# Trigger gate.
ENABLED=$(config_get triggers stop)
INJECT=$(config_get "" inject_enabled)
if [ "$ENABLED" != "true" ]; then
  log "skip: triggers.stop=$ENABLED"
  exit 0
fi
if [ "$INJECT" != "true" ]; then
  log "skip: inject_enabled=$INJECT (scaffold mode)"
  exit 0
fi

# Already spawned a critic this turn?
# Heuristic: check transcript for Agent tool use in the most recent assistant turn.
if [ -f "$TRANSCRIPT" ]; then
  RECENT_TURN=$(tail -200 "$TRANSCRIPT" 2>/dev/null || echo "")
  if echo "$RECENT_TURN" | grep -q '"name":"Agent"' 2>/dev/null; then
    log "critic subagent already spawned this turn — allowing stop"
    exit 0
  fi
fi

# Block and demand critic.
echo $((BLOCKS + 1)) > "$COUNTER_FILE"
INSTRUCTION=$(build_critic_instruction)
log "blocking stop, injecting critic instruction (${#INSTRUCTION} chars)"

jq -n --arg reason "$INSTRUCTION" '{
  decision: "block",
  reason: $reason
}'
