# Skills vs subagents vs hooks (when to use which)

Four mechanisms, each for a different job. Picking the wrong one is why setups feel noisy.

| Mechanism | Loads | Use it for | Adherence |
|---|---|---|---|
| **CLAUDE.md** | Every session | Short, always-true rules & conventions | Advisory (~70%) |
| **Skills** (`.claude/skills/*/SKILL.md`) | On demand, by description match | Richer workflows / domain knowledge that's only *sometimes* relevant | Advisory |
| **Subagents** (`.claude/agents/*.md`) | When delegated to | Isolated context — big reads, research, an independent review | Runs in its own window |
| **Hooks** (`settings.json`) | On an event (Stop, SessionEnd, …) | Things that must happen **every time, deterministically** | Guaranteed |

## The rules that matter

- **Keep CLAUDE.md lean.** It loads every turn; bloat makes real rules get ignored. If a rule is only sometimes relevant, make it a skill.
- **Skill descriptions are the routing layer.** The model picks a skill from its `description` alone (it sees ~50 tokens before loading the body). A vague description never fires. Start every description with a precise *"Use when…"*.
- **Subagents keep your main context clean.** When the agent needs to read 30 files to answer something, send a subagent — it reads in its own window and returns a summary. The same isolation is why a fresh-context reviewer grades honestly: it didn't write the code.
- **Hooks are for guarantees.** Skills are advisory; a Stop hook that blocks on failing tests is not. Use hooks for the few things that must be enforced, not for guidance.

## In this repo

- `dev-core` → CLAUDE.md-style always-on (the operating loop).
- `engineering-fundamentals`, `/plan`, `/ship`, `/debug`, `/refactor`, `/audit`, `/research`, `/optimize`, `/ideate`, `brain-capture` → on-demand skills.
- `senior-review`, `fact-check`, `circuit-breaker`, `prompt-coach` → subagents (the independent passes: adversarial review + evidence verification + stop-the-line on dead-end/no-value work + a retro coach that teaches the human better prompting).
- `guard`, `verify-gate`, `session-journal` → hooks (the deterministic layer: a PreToolUse safeguard that blocks catastrophic/rule-breaking calls, the test gate, and the auto-journal). See [`safeguards.md`](safeguards.md).
