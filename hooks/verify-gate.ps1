# Verify gate - Claude Code **Stop** hook.
# Blocks the agent from finishing a turn while a project's verify command
# (tests/build/lint) is failing. The deterministic backstop behind "done".
#
# OPT-IN per project: does nothing unless the project has a one-line
# `.claude/verify.cmd` file (e.g. `npm test`, `pytest -q`, `flutter test`).
# Only runs when git shows uncommitted changes, so chat-only turns aren't gated.
$ErrorActionPreference = 'SilentlyContinue'

# Don't gate a nested hook-spawned run.
if ($env:SENIOR_CLAUDE_HOOK -eq '1') { exit 0 }

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $d = $raw | ConvertFrom-Json } catch { exit 0 }
$cwd = $d.cwd
if (-not $cwd -or -not (Test-Path $cwd)) { exit 0 }

$marker = Join-Path $cwd ".claude\verify.cmd"
if (-not (Test-Path $marker)) { exit 0 }
$cmd = (Get-Content $marker -Raw).Trim()
if (-not $cmd) { exit 0 }

Set-Location $cwd

# If it's a git repo, only gate when there are uncommitted changes.
$inGit = (git rev-parse --is-inside-work-tree 2>$null)
if ($inGit -eq 'true') {
  $dirty = git status --porcelain 2>$null
  if (-not $dirty) { exit 0 }
}

$out  = cmd /c $cmd 2>&1 | Out-String
$code = $LASTEXITCODE

if ($code -ne 0) {
  $tail = ($out -split "`n" | Select-Object -Last 40) -join "`n"
  [Console]::Error.WriteLine("VERIFY GATE: ``$cmd`` failed (exit $code). Do not finish - fix the failures, then re-run. Tail of output:`n$tail")
  exit 2   # exit 2 => block the stop; stderr is shown to the agent
}
exit 0
