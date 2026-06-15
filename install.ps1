# Install Senior Claude into your Claude Code config (~/.claude by default).
# Copies skills, the senior-review agent, and hook scripts. Idempotent.
$ErrorActionPreference = 'Stop'

$ClaudeDir = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME '.claude' }
$Src = $PSScriptRoot

foreach ($d in 'skills','agents','hooks') {
  New-Item -ItemType Directory -Force (Join-Path $ClaudeDir $d) | Out-Null
}

Copy-Item -Recurse -Force (Join-Path $Src 'skills\*') (Join-Path $ClaudeDir 'skills')
Copy-Item -Force (Join-Path $Src 'agents\*.md') (Join-Path $ClaudeDir 'agents')
Copy-Item -Force (Join-Path $Src 'hooks\*.ps1') (Join-Path $ClaudeDir 'hooks')
Copy-Item -Force (Join-Path $Src 'hooks\*.sh')  (Join-Path $ClaudeDir 'hooks')

Write-Host "[OK] Installed skills, agents, and hook scripts into $ClaudeDir"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Hooks (optional): merge hooks/settings.example.json into $ClaudeDir\settings.json"
Write-Host "     and replace <HOME> with $HOME. See docs/05-hooks.md."
Write-Host "  2. The brain (optional): point skills/brain-capture at your notes vault. See docs/03-the-brain.md."
Write-Host "  3. Per-repo test gate (optional): add a one-line .claude/verify.cmd to a project (e.g. 'npm test')."
