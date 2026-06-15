#!/usr/bin/env bash
# Verify gate — Claude Code **Stop** hook (bash port of verify-gate.ps1).
# Blocks the agent from ending a turn while a project's verify command fails.
# OPT-IN per project via a one-line `<repo>/.claude/verify.cmd`. Only runs when
# git shows uncommitted changes. Fails open on any parse error.

# Don't gate a nested hook-spawned run.
[ "${SENIOR_CLAUDE_HOOK:-}" = "1" ] && exit 0

input="$(cat)"
[ -z "$input" ] && exit 0

if command -v jq >/dev/null 2>&1; then
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
else
  cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
fi
if [ -z "$cwd" ] || [ ! -d "$cwd" ]; then exit 0; fi

marker="$cwd/.claude/verify.cmd"
[ -f "$marker" ] || exit 0
cmd="$(tr -d '\r' < "$marker" | sed '/^[[:space:]]*$/d' | head -n1)"
[ -z "$cmd" ] && exit 0

cd "$cwd" || exit 0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  [ -z "$(git status --porcelain 2>/dev/null)" ] && exit 0
fi

if out="$(bash -lc "$cmd" 2>&1)"; then
  exit 0
else
  code=$?
  tail_out="$(printf '%s\n' "$out" | tail -n 40)"
  printf 'VERIFY GATE: `%s` failed (exit %s). Do not finish - fix the failures, then re-run. Tail of output:\n%s\n' "$cmd" "$code" "$tail_out" >&2
  exit 2   # block the stop; stderr is shown to the agent
fi
