# Hooks (the deterministic layer)

Skills and CLAUDE.md are advisory — the model follows them most of the time. Hooks are **guaranteed**: Claude Code runs them on an event, no matter what the model decides. Use them for the few things that must always happen.

Two hooks ship here. Both are **opt-in per project** (safe by default — they do nothing until you turn them on for a repo), never block your shell, and never recurse.

## `verify-gate.ps1` — the test gate (Stop hook)

Blocks the agent from ending a turn while your tests/build are failing. This is what turns "looks done" into "proven done."

- **Enable per repo:** drop a one-line command in `<repo>/.claude/verify.cmd`, e.g.:
  - `npm test` · `pytest -q` · `flutter test` · `npm run lint && npm run build`
- **Behaviour:** when the repo has uncommitted changes, the hook runs that command after each turn. If it exits non-zero, the hook returns exit code 2 — Claude Code blocks the turn and feeds the failing output back so the agent fixes it. (Claude Code overrides after 8 consecutive blocks, so it can't deadlock.)
- **Only fires on real changes** (git dirty), so chat-only turns are never gated.

## `session-journal.ps1` — auto work-journal (SessionEnd hook)

At session end, spawns a detached headless `claude -p` run that reads the session transcript and writes a work-journal note via `brain-capture`.

- **Enable per repo:** create an empty `<repo>/.claude/journal.enabled` marker file.
- **Behaviour:** runs in the background (never delays your exit), scoped tools only, recursion-guarded via an env var so the journaling run doesn't trigger itself.
- **Cost:** it spawns a short headless run per session. Logs to `%TEMP%\sc-journal-<id>.txt.log`.

## Install & wiring

Run `install.ps1` (Windows) or `install.sh` (macOS/Linux) to copy the skills, agents, and **both** hook variants into `~/.claude`. Then merge `hooks/settings.example.json` into `~/.claude/settings.json` and replace `<HOME>` with your absolute home path (Claude Code does not expand env vars inside hook commands).

## Both shells ship

Each hook comes in two forms — point `settings.json` at the one for your OS:

- **Windows:** `verify-gate.ps1` · `session-journal.ps1`
- **macOS / Linux:** `verify-gate.sh` · `session-journal.sh`

The logic is identical (read the hook JSON from stdin, gate on the same `.claude/verify.cmd` / `.claude/journal.enabled` markers, detach the journal run); only the shell differs. The bash journal logs to `$TMPDIR/sc-journal-<id>.log`, the PowerShell one to `%TEMP%\sc-journal-<id>.txt.log`.

## Safety notes

- Both hooks fail open: any parse error or missing field → exit 0 (do nothing).
- The verify gate runs your command via `cmd /c`; trust your own `verify.cmd`.
- The journal run uses `--permission-mode acceptEdits` with a scoped `--allowedTools` list — review it before enabling if you're cautious.
