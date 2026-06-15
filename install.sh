#!/usr/bin/env bash
# Install Senior Claude into your Claude Code config (~/.claude by default).
# Copies skills, the senior-review agent, and hook scripts. Idempotent.
set -e

CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/hooks"

cp -r "$SRC"/skills/* "$CLAUDE_DIR/skills/"
cp "$SRC"/agents/*.md "$CLAUDE_DIR/agents/"
cp "$SRC"/hooks/*.sh "$CLAUDE_DIR/hooks/" 2>/dev/null || true
cp "$SRC"/hooks/*.ps1 "$CLAUDE_DIR/hooks/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR"/hooks/*.sh 2>/dev/null || true

echo "✓ Installed skills, agents, and hook scripts into $CLAUDE_DIR"
echo
echo "Next steps:"
echo "  1. Hooks (optional): merge hooks/settings.example.json into $CLAUDE_DIR/settings.json"
echo "     and replace <HOME> with $HOME. See docs/05-hooks.md."
echo "  2. The brain (optional): point skills/brain-capture at your notes vault. See docs/03-the-brain.md."
echo "  3. Per-repo test gate (optional): add a one-line .claude/verify.cmd to a project (e.g. 'npm test')."
