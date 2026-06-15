#!/usr/bin/env bash
# Session journal — Claude Code **SessionEnd** hook (bash port of session-journal.ps1).
# At session end, spawns a detached headless `claude -p` run that writes a
# work-journal note via the brain-capture skill. OPT-IN per project via a
# `<repo>/.claude/journal.enabled` marker. Never blocks exit; never recurses.

[ "${SENIOR_CLAUDE_HOOK:-}" = "1" ] && exit 0

input="$(cat)"
[ -z "$input" ] && exit 0

if command -v jq >/dev/null 2>&1; then
  transcript="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
  sid="$(printf '%s' "$input" | jq -r '.session_id // empty')"
else
  transcript="$(printf '%s' "$input" | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
  cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
  sid="$(printf '%s' "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
fi

if [ -z "$transcript" ] || [ ! -f "$transcript" ]; then exit 0; fi
[ -z "$cwd" ] && exit 0
[ -f "$cwd/.claude/journal.enabled" ] || exit 0   # opt-in

prompt="A coding session just ended. Invoke the Brain Capture skill and write a Mode B work-journal note for THIS session. Read the session transcript (JSONL) at: ${transcript} . Reconstruct what was done to the minute: tasks (quote the user's requests), key actions and commands, files created/edited with paths, decisions and reasoning, outcomes, errors and resolutions, blockers, next steps. Append if today's note already exists. Exclude secrets. Then stop."

# Detached so session exit isn't blocked; recursion-guarded via env var.
SENIOR_CLAUDE_HOOK=1 nohup claude -p "$prompt" \
  --permission-mode acceptEdits \
  --allowedTools 'Read,Write,Edit,Glob,Grep' \
  >"${TMPDIR:-/tmp}/sc-journal-${sid}.log" 2>&1 &

exit 0
