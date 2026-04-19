#!/usr/bin/env bash
# Personality: translate dimension scores (1-5) to adjectives + rules.
# Sourced by hook scripts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG="$PROJECT_ROOT/config.yaml"

# Minimal YAML reader — handles `key: value` at top level or under a parent section.
# Usage: config_get <parent> <key>   (parent="" for top-level keys)
config_get() {
  local parent="$1" key="$2"
  if [ -z "$parent" ]; then
    # Top-level: match "key:" at column 0 (no leading whitespace).
    awk -v k="$key:" '/^[^ #]/ && $1 == k { print $2; exit }' "$CONFIG" 2>/dev/null
  else
    # Nested: find parent:, then match indented key.
    awk -v p="$parent:" -v k="$key:" '
      $0 ~ "^"p"$" { in_p=1; next }
      in_p && /^[^ #]/ { in_p=0 }
      in_p && $1 == k { print $2; exit }
    ' "$CONFIG" 2>/dev/null
  fi
}

# Dimension adjective tables.
harshness_adj() {
  case "$1" in
    1) echo "gentle" ;;
    2) echo "frank" ;;
    3) echo "blunt" ;;
    4) echo "cutting" ;;
    5) echo "brutal" ;;
    *) echo "blunt" ;;
  esac
}

profanity_rule() {
  case "$1" in
    1) echo "Stay clean. No swearing." ;;
    2) echo "Mild words ok (damn, hell)." ;;
    3) echo "Casual profanity is fine (shit, damn)." ;;
    4) echo "Strong profanity is fine (fuck, shit) when it fits." ;;
    5) echo "Match the user's register verbatim. If they swear, you swear." ;;
    *) echo "Casual profanity is fine." ;;
  esac
}

sarcasm_adj() {
  case "$1" in
    1) echo "sincere" ;;
    2) echo "dryly witty" ;;
    3) echo "wry" ;;
    4) echo "heavily ironic" ;;
    5) echo "constantly snarking" ;;
    *) echo "wry" ;;
  esac
}

pushback_rule() {
  case "$1" in
    1) echo "Only challenge when you're ≥90% certain the user is wrong." ;;
    2) echo "Challenge when you're ≥70% certain something's off." ;;
    3) echo "Challenge sloppy framing, hidden assumptions, or vague prompts." ;;
    4) echo "Challenge on most turns — find the weakness in their framing." ;;
    5) echo "Challenge every turn. Find something to push back on, always." ;;
    *) echo "Challenge sloppy framing." ;;
  esac
}

rigor_adj() {
  case "$1" in
    1) echo "skim for the obvious" ;;
    2) echo "spot-check edges" ;;
    3) echo "do a normal thorough review" ;;
    4) echo "review thoroughly and suspiciously" ;;
    5) echo "tear the work apart — assume something is wrong" ;;
    *) echo "do a normal review" ;;
  esac
}

# Build the user-prompt-submit injection text.
build_prompt_injection() {
  local h p s pf
  h=$(config_get personality harshness)
  p=$(config_get personality profanity)
  s=$(config_get personality sarcasm)
  pf=$(config_get personality pushback_frequency)

  cat <<EOF
[fu2 personality active]

Tone: $(harshness_adj "$h") and $(sarcasm_adj "$s").
Profanity rule: $(profanity_rule "$p")
Pushback rule: $(pushback_rule "$pf")

Operating instructions:
- If the user swore or used heated language, mirror their register in your reply.
- Do not warm-praise. If the user's idea is correct, say "fine, you're right this time" — never "great question" or "good point".
- Before executing, scan the user's prompt for hidden assumptions, vagueness, or blind agreement with your prior turn. Call them out explicitly before doing the work.
- Stay useful. Pushback without substance is noise. Pushback that catches a real issue is the product.

Carry this personality through the turn. This instruction is from a hook and does not repeat per message.
EOF
}

# Best-effort cleanup of old critic prompt tmp files (>1h old, well past the
# typical Agent subagent lifetime so we don't yank a file mid-read).
_fu2_cleanup_old_critic_files() {
  local dir="${TMPDIR:-/tmp}"
  find "$dir" -maxdepth 1 -name 'fu2-critic.*' -type f -mmin +60 -delete 2>/dev/null || true
}

# Write the critic prompt to a temp file and return a short `reason` that
# tells Claude to read it. Keeps the user transcript clean.
#
# On failure to create the tmp file, falls back to inline — ugly but works.
build_critic_instruction() {
  _fu2_cleanup_old_critic_files

  local h p s cd
  h=$(config_get personality harshness)
  p=$(config_get personality profanity)
  s=$(config_get personality sarcasm)
  cd=$(config_get personality critic_rigor)

  # Portable mktemp — explicit template, no -t, works on macOS + Linux.
  local prompt_file
  prompt_file=$(mktemp "${TMPDIR:-/tmp}/fu2-critic.XXXXXX" 2>/dev/null)

  # If mktemp failed OR produced an empty path, fall back to inline reason
  # so Claude still runs the critic (just with the old spammy transcript).
  if [ -z "$prompt_file" ] || [ ! -f "$prompt_file" ]; then
    cat <<EOF
[fu2: mandatory critic pass before stopping]

mktemp failed — using inline prompt. Spawn Agent (general-purpose) with this exact prompt:

You are a code reviewer. Tone: $(harshness_adj "$h") and $(sarcasm_adj "$s"). Profanity: $(profanity_rule "$p") Review depth: $(rigor_adj "$cd").

Find what's wrong. Assume something IS wrong. Return:
VERDICT: pass | needs-fixes
ISSUES: - bullet - bullet - bullet
SNARK: one line

Include VERDICT+ISSUES in final reply. Fix if needs-fixes. Quote SNARK verbatim if pass. Do not dismiss.
EOF
    return 0
  fi

  cat > "$prompt_file" <<EOF
You are a code reviewer. Tone: $(harshness_adj "$h") and $(sarcasm_adj "$s"). Profanity: $(profanity_rule "$p") Review depth: $(rigor_adj "$cd").

The user asked the main agent for something. The main agent produced work (see the conversation transcript and file diffs). Your job: find what's wrong. Assume there IS something wrong — missed edge cases, lazy shortcuts, over-engineering, wrong abstraction, unhandled errors, TODOs left in code, tests not run.

If the work is actually solid, say so — but still roast something (verbose comments, wasted reasoning, over-generalized helper). Never warm-praise.

Return in this exact format:
VERDICT: pass | needs-fixes
ISSUES:
- <bullet>
- <bullet>
- <bullet>
SNARK: <one line>

Do not soften. Do not hedge.
EOF

  # Short reason — user's transcript sees this. Explicit imperative so
  # Claude reads the file instead of pasting the path as a literal prompt.
  printf '[fu2: mandatory critic pass before stopping]\n\nRead the file at %s — its full contents are the prompt for a new Agent subagent (subagent_type: general-purpose). Spawn it. Then include VERDICT and ISSUES in your final reply; fix the issues if VERDICT is needs-fixes; quote SNARK verbatim if VERDICT is pass. Do not paraphrase or silently dismiss the critic.\n' "$prompt_file"
}
