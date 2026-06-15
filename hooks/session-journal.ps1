# Session journal — Claude Code **SessionEnd** hook.
# At session end, spawns a detached, headless `claude -p` run that reads the
# session transcript and writes a work-journal note via the brain-capture skill.
# Makes "capture everything" automatic instead of advisory.
#
# OPT-IN per project: does nothing unless the project's cwd contains a
# `.claude/journal.enabled` marker file. Never blocks exit; never recurses.
$ErrorActionPreference = 'SilentlyContinue'

# Recursion guard: the spawned run inherits this; its own SessionEnd hook exits.
if ($env:SENIOR_CLAUDE_HOOK -eq '1') { exit 0 }

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $d = $raw | ConvertFrom-Json } catch { exit 0 }

$transcript = $d.transcript_path
$cwd        = $d.cwd
$sessionId  = $d.session_id

if (-not $transcript -or -not (Test-Path $transcript)) { exit 0 }
if (-not $cwd) { exit 0 }
if (-not (Test-Path (Join-Path $cwd ".claude\journal.enabled"))) { exit 0 }   # opt-in

$promptText = @"
A coding session just ended. Invoke the Brain Capture skill and write a Mode B
work-journal note for THIS session. Read the session transcript (JSONL) at:
$transcript
Reconstruct what was done to the minute: tasks (quote the user's requests), key
actions and commands, files created/edited with paths, decisions and reasoning,
outcomes, errors and resolutions, blockers, next steps. Append if today's note
already exists. Exclude secrets. Then stop.
"@

$promptFile = Join-Path $env:TEMP ("sc-journal-$sessionId.txt")
Set-Content -Path $promptFile -Value $promptText -Encoding utf8

# Launch detached so session exit is not blocked. Recursion-guarded via env var.
$allowed = 'Read,Write,Edit,Glob,Grep'
$inner = "`$env:SENIOR_CLAUDE_HOOK='1'; claude -p (Get-Content -Raw '$promptFile') --permission-mode acceptEdits --allowedTools '$allowed' *> '$($promptFile).log'"
Start-Process -FilePath 'powershell.exe' -ArgumentList '-NoProfile','-Command',$inner -WindowStyle Hidden

exit 0
