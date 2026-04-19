#!/usr/bin/env bash
# UserPromptSubmit hook: inject personality-flavored pushback instructions.
# Stdin: JSON with prompt, transcript_path, session_id, cwd.
# Stdout: JSON with hookSpecificOutput.additionalContext to append to the prompt.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/fu2.log"
mkdir -p "$LOG_DIR"

# shellcheck source=../lib/personality.sh
source "$PROJECT_ROOT/lib/personality.sh"

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] user-prompt-submit $*" >> "$LOG_FILE"; }

# Read hook input.
HOOK_INPUT=$(cat)
PROMPT=$(echo "$HOOK_INPUT" | jq -r '.prompt // ""' 2>/dev/null || echo "")
SESSION=$(echo "$HOOK_INPUT" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")

log "session=$SESSION prompt_len=${#PROMPT}"

# Trigger gate.
ENABLED=$(config_get triggers user_prompt_submit)
INJECT=$(config_get "" inject_enabled)
if [ "$ENABLED" != "true" ]; then
  log "skip: triggers.user_prompt_submit=$ENABLED"
  exit 0
fi
if [ "$INJECT" != "true" ]; then
  log "skip: inject_enabled=$INJECT (scaffold mode)"
  exit 0
fi

# Build and emit injection.
INJECTION=$(build_prompt_injection)
log "injecting ${#INJECTION} chars"

jq -n --arg ctx "$INJECTION" '{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: $ctx
  }
}'
