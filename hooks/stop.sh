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

# ---- pushback_frequency gate --------------------------------------------------
# pf now governs BOTH main-agent challenging (via prompt injection) AND whether
# the critic subagent fires. Mapping:
#   1 → never fire critic
#   2 → fire only on substantial file edits (≥3)
#   3 → fire on any file edit
#   4 → fire on any tool call
#   5 → fire on any tool call (same as 4, preserved for future)
# Universal skip above all: if the agent produced no tool calls this turn,
# there's nothing to critique — exit regardless of pf.
PF=$(config_get personality pushback_frequency)
PF=${PF:-3}

TOOL_CALLS=0
FILE_EDITS=0
if [ -f "$TRANSCRIPT" ]; then
  # Find the last ACTUAL user turn (user-typed text, not tool_result wrapped
  # as role:user — those carry a tool_use_id marker).
  last_user=$(grep -n '"type":"user"' "$TRANSCRIPT" 2>/dev/null | grep -v '"tool_use_id"' | tail -1 | cut -d: -f1 || true)
  if [ -n "$last_user" ]; then
    turn_slice=$(tail -n +"$last_user" "$TRANSCRIPT" 2>/dev/null || true)
  else
    turn_slice=$(cat "$TRANSCRIPT" 2>/dev/null || true)
  fi
  TOOL_CALLS=$(printf '%s' "$turn_slice" | grep -c '"type":"tool_use"' 2>/dev/null || true)
  FILE_EDITS=$(printf '%s' "$turn_slice" | grep -cE '"name":"(Edit|Write|MultiEdit|NotebookEdit)"' 2>/dev/null || true)
  TOOL_CALLS=${TOOL_CALLS:-0}
  FILE_EDITS=${FILE_EDITS:-0}
fi

if [ "$TOOL_CALLS" -eq 0 ]; then
  log "skip critic: no tool_use this turn (pf=$PF, nothing to review)"
  exit 0
fi

case "$PF" in
  1)
    log "skip critic: pf=1 disables critic firing"
    exit 0
    ;;
  2)
    if [ "$FILE_EDITS" -lt 3 ]; then
      log "skip critic: pf=2 needs ≥3 file edits (have $FILE_EDITS, tool_calls=$TOOL_CALLS)"
      exit 0
    fi
    ;;
  3)
    if [ "$FILE_EDITS" -eq 0 ]; then
      log "skip critic: pf=3 needs ≥1 file edit (tool_calls=$TOOL_CALLS, no edits)"
      exit 0
    fi
    ;;
  *) ;;  # 4, 5, anything else: any tool call suffices (universal skip above)
esac

log "fire critic: pf=$PF tool_calls=$TOOL_CALLS file_edits=$FILE_EDITS"
# ---- end gate ----------------------------------------------------------------

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
