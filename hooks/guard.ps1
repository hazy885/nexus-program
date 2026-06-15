# Guard - Claude Code PreToolUse hook (Windows port of guard.sh).
# Deterministically BLOCKS catastrophic or rule-violating tool calls before they run.
#   exit 2 -> DENY (reason to stderr, shown to the agent);  exit 0 -> allow.
# Fail-OPEN by design: any parse error -> allow. A safety net, not a sandbox.
# ASCII-only on purpose: Windows PowerShell 5.1 reads -File as ANSI, so non-ASCII breaks parsing.

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try { $data = $raw | ConvertFrom-Json } catch { exit 0 }
$tool = $data.tool_name
if (-not $tool) { exit 0 }

function Deny([string]$why) { [Console]::Error.WriteLine("GUARD: blocked - $why"); exit 2 }

if ($tool -eq 'Bash') {
    $cmd = [string]$data.tool_input.command
    if ([string]::IsNullOrWhiteSpace($cmd)) { exit 0 }
    $n = ($cmd -replace '\s+', ' ')

    # Catastrophic / irreversible
    if ($n -imatch 'rm +(-[a-z]*r[a-z]*f[a-z]*|-[a-z]*f[a-z]*r[a-z]*|-r +-f|-f +-r|--recursive +--force) +(/|~|/\*|\$HOME)( |/|$)') { Deny 'recursive force-delete of a root/home path' }
    if ($n -imatch '\bmkfs(\.[a-z0-9]+)?\b|\bdd\b[^|]*\bof=/dev/|> */dev/(sd|nvme|hd)[a-z]') { Deny 'raw disk write / format' }

    # Bypassing the safety rails (project git rules)
    if ($n -imatch '\bgit +add\b[^&|;]*(-A\b|--all\b| \.( |$))') { Deny "blanket 'git add -A/.' - stage files by name so you cannot sweep in a .env or secret" }
    if ($n -imatch '\bgit +push\b[^&|;]*(--force\b|-f\b|--force-with-lease\b)') { Deny 'git force-push - ask first; the default rule forbids it' }
    if ($n -imatch '--no-verify\b|--no-gpg-sign\b|commit\.gpgsign=false') { Deny 'bypassing git hooks/signing (--no-verify / --no-gpg-sign)' }

    # Remote code execution
    if ($n -imatch '(curl|wget)[^|]*\| *(sudo +)?(bash|sh|zsh)\b') { Deny 'piping a network download directly into a shell' }
    exit 0
}

if ($tool -eq 'Write' -or $tool -eq 'Edit' -or $tool -eq 'MultiEdit') {
    $body = @($data.tool_input.content, $data.tool_input.new_string, $data.tool_input.contents) -join "`n"
    if ([string]::IsNullOrWhiteSpace($body)) { exit 0 }

    if ($body -match 'BEGIN [A-Z0-9 ]*PRIVATE KEY') { Deny 'private key written into a file' }
    if ($body -cmatch 'AKIA[0-9A-Z]{16}') { Deny 'AWS access key id in file content' }
    if ($body -match 'gh[posru]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{60}') { Deny 'GitHub token in file content' }
    if ($body -match 'xox[baprs]-[A-Za-z0-9-]{10}') { Deny 'Slack token in file content' }
    if ($body -match 'sk-ant-[A-Za-z0-9_-]{20}|sk-[A-Za-z0-9]{32}') { Deny 'API secret key in file content' }
    if ($body -match 'AIza[0-9A-Za-z_-]{35}') { Deny 'Google API key in file content' }
    exit 0
}

exit 0
