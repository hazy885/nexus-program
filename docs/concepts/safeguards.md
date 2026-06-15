# Safeguards, hallucination prevention & rule enforcement

A senior is trusted because the dangerous mistakes are *structurally* hard to make, not because they promise to be careful. This is the defense-in-depth model: what stops the agent from wrecking something, inventing facts, or breaking the rules — and, honestly, where each layer's limits are.

## The three layers (weakest → strongest guarantee)

| Layer | Mechanism | Guarantee |
|---|---|---|
| **Advisory** | `dev-core` + the playbooks + your CLAUDE.md | The model follows them **most** of the time (~70%). Shapes default behavior; does not *enforce*. |
| **Independent agents** | `fact-check`, `senior-review`, `circuit-breaker` | A fresh context with no stake re-checks the work. Catches what the author can't see. |
| **Deterministic hooks** | `guard` (PreToolUse), `verify-gate` (Stop) | **Always runs, no matter what the model decides.** This is the real enforcement. |

The rule: **anything that actually matters rides on the bottom two rows.** Don't trust advice to be a guardrail — make it a hook or an agent.

## Safeguards — the `guard` hook (PreToolUse)

`guard.ps1` / `guard.sh` runs *before* every tool call and can **block** it (exit 2). It stops the catastrophic and the rule-breaking before they happen:

- **Catastrophic system actions** — `rm -rf` on `/`, `~`, `$HOME`, `/*`; disk format / raw `dd` to a device; fork bombs.
- **Bypassing the rails** — blanket `git add -A` / `git add .` (so a stray `.env` can't be swept in); `git push --force`; `--no-verify` / `--no-gpg-sign` (skipping hooks/signing).
- **Remote code execution** — piping a network download (`curl … | bash`) straight into a shell.
- **Secrets into files** — blocks a Write/Edit whose content contains a private key, AWS/Google/Slack/GitHub token, or an `sk-…` API key.

Enable it by adding the `PreToolUse` block from `settings.example.json`. It's **fail-open** (any parse error → allow) and a **safety net, not a sandbox** — it catches the obvious forms, not every clever variation. Tune the patterns to your team's rules; they're plain regex.

## Hallucination prevention

No single trick eliminates hallucination; this stacks several so a fabricated claim has to survive all of them:

- **Never present a guess as fact** (`dev-core` step 0) — confidence must be grounded in evidence; state uncertainty plainly instead.
- **Recall before asserting** — read the brain and the actual code/data first; never assume from a filename ([`the-brain.md`](the-brain.md), [`../playbooks/handling-uncertainty.md`](../playbooks/handling-uncertainty.md)).
- **Research, don't rely on training memory** — for anything version/API-specific, search and **cite what each source confirmed** ([`../playbooks/researching.md`](../playbooks/researching.md)).
- **Grade the evidence** — ran-it > read-it > docs > precedent > reasoning > intuition; say which rung a claim sits on ([`../playbooks/reasoning-about-solutions.md`](../playbooks/reasoning-about-solutions.md)).
- **`fact-check` agent** — a fresh context verifies load-bearing claims against sources and returns **CONFIRMED / REFUTED / UNVERIFIABLE** with citations; "unverifiable" is an allowed answer, a fabrication is not.
- **`verify-gate` hook** — turns "it works" from a claim into proof: the turn can't end green while tests are red.

Together: advice discourages it, the evidence rules make it visible, `fact-check` catches the load-bearing ones, and `verify-gate` makes "done" mean *demonstrated*.

## Rule enforcement — advisory vs. enforced

Most rules live in `dev-core` and your CLAUDE.md and are *advisory*. A few are important enough to make **deterministic** — the `guard` hook turns these from "please don't" into "can't":

| Rule | Enforced by |
|---|---|
| No `git add -A` / `.` (avoid leaking secrets) | `guard` (blocks the command) |
| No force-push / no `--no-verify` unless asked | `guard` |
| No secrets written into files | `guard` (scans Write/Edit content) |
| No catastrophic `rm -rf` / disk writes | `guard` |
| Don't declare "done" while tests fail | `verify-gate` |
| Stay in scope / verify with evidence / cite sources | advisory + `senior-review` / `fact-check` |

**To enforce your own rule:** add a pattern to `guard` (a blocked command or a required marker), or add an agent pass for judgment calls. If a rule keeps getting violated, that's the signal to move it down a layer — from advice to a hook.

## Honest limitations

- Hooks match **shell commands and file content**, not the model's reasoning — they can't catch a bad decision that doesn't touch a blocked pattern.
- The `guard` denylist is **not exhaustive or unbypassable**; a determined rephrase can evade it. It raises the floor, it isn't a security boundary.
- Advisory rules are still ~70% — that's *why* the catastrophic ones are hooks.
- Anti-hallucination measures **reduce, not eliminate.** The durable guarantee is the deterministic part: `fact-check`'s citations and `verify-gate`'s real test output. Trust those.
