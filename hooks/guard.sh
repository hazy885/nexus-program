#!/usr/bin/env bash
# Guard — Claude Code **PreToolUse** hook. Deterministically BLOCKS catastrophic
# or rule-violating tool calls *before* they run. This is the enforcement layer:
# skills are advisory (~70%), this is not.
#
#   exit 2  -> DENY the tool call (reason printed to stderr, shown to the agent)
#   exit 0  -> allow
#
# Fail-OPEN by design: any parse error, missing field, or unmatched call -> allow.
# A safety net, not a sandbox — it stops the obvious catastrophes, not every clever
# variation. Tune the patterns below to your team's rules.

input="$(cat)"
[ -z "$input" ] && exit 0

if command -v jq >/dev/null 2>&1; then
  tool="$(printf '%s' "$input" | jq -r '.tool_name // empty')"
else
  tool="$(printf '%s' "$input" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
fi

deny() { printf 'GUARD: blocked — %s\n' "$1" >&2; exit 2; }

case "$tool" in
  Bash)
    if command -v jq >/dev/null 2>&1; then
      cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
    else
      cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)"[^"]*}.*/\1/p')"
    fi
    [ -z "$cmd" ] && exit 0
    norm="$(printf '%s' "$cmd" | tr -s '[:space:]' ' ')"

    # --- Catastrophic / irreversible system actions ---
    printf '%s' "$norm" | grep -Eqi 'rm +(-[a-z]*r[a-z]*f[a-z]*|-[a-z]*f[a-z]*r[a-z]*|-r +-f|-f +-r|--recursive +--force|--force +--recursive) +(/|~|/\*|\$HOME)( |/|$)' \
      && deny "recursive force-delete of a root/home path (rm -rf on /, ~, \$HOME, /*)"
    printf '%s' "$norm" | grep -Eq ':\(\) *\{ *: *\| *: *& *\} *; *:' && deny "fork bomb"
    printf '%s' "$norm" | grep -Eqi '\bmkfs(\.[a-z0-9]+)?\b|\bdd\b[^|]*\bof=/dev/|> */dev/(sd|nvme|hd)[a-z]' && deny "raw disk write / format"

    # --- Bypassing the safety rails (enforces the project's own git rules) ---
    printf '%s' "$norm" | grep -Eqi '\bgit +add\b[^&|;]*(-A\b|--all\b| \.( |$))' \
      && deny "blanket 'git add -A/.' — stage files by name so you can't sweep in a .env or secret"
    printf '%s' "$norm" | grep -Eqi '\bgit +push\b[^&|;]*(--force\b|-f\b|--force-with-lease\b)' \
      && deny "git force-push — ask first; the default rule forbids it"
    printf '%s' "$norm" | grep -Eqi -- '--no-verify\b|--no-gpg-sign\b|commit\.gpgsign=false' \
      && deny "bypassing git hooks/signing (--no-verify / --no-gpg-sign)"

    # --- Remote code execution: pipe-from-network straight into a shell ---
    printf '%s' "$norm" | grep -Eqi '(curl|wget)[^|]*\| *(sudo +)?(bash|sh|zsh)\b' \
      && deny "piping a network download directly into a shell — download, read, then run"
    exit 0
    ;;

  Write|Edit|MultiEdit)
    if command -v jq >/dev/null 2>&1; then
      body="$(printf '%s' "$input" | jq -r '[.tool_input.content, .tool_input.new_string, .tool_input.contents] | map(select(. != null)) | join("\n")')"
    else
      body="$input"
    fi
    [ -z "$body" ] && exit 0

    # --- Secrets must never be written into files ---
    printf '%s' "$body" | grep -Eq 'BEGIN [A-Z0-9 ]*PRIVATE KEY'            && deny "private key written into a file"
    printf '%s' "$body" | grep -Eq 'AKIA[0-9A-Z]{16}'                       && deny "AWS access key id in file content"
    printf '%s' "$body" | grep -Eq 'gh[posru]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{60}' && deny "GitHub token in file content"
    printf '%s' "$body" | grep -Eq 'xox[baprs]-[A-Za-z0-9-]{10}'            && deny "Slack token in file content"
    printf '%s' "$body" | grep -Eq 'sk-ant-[A-Za-z0-9_-]{20}|sk-[A-Za-z0-9]{32}' && deny "API secret key in file content"
    printf '%s' "$body" | grep -Eq 'AIza[0-9A-Za-z_-]{35}'                  && deny "Google API key in file content"
    exit 0
    ;;

  *)
    exit 0
    ;;
esac
