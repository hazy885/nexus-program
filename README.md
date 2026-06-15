<div align="center">

# Senior Claude

### Turning Claude Code from a junior dev into a senior engineer.

*A real, copy-pasteable setup: skills, persistent memory, adversarial review, and hard verification gates — so the agent plans, checks its own work, and remembers.*

</div>

---

## The problem

Out of the box, an AI coding agent behaves like a fast, eager **junior**: it jumps straight to code, makes confident assumptions, over-engineers, forgets everything between sessions, and tells you "done" without proving it.

A **senior engineer** does the opposite. They:

- **Understand before they build** — restate the problem, spend effort on the right problem.
- **Stop and ask** when an assumption is load-bearing instead of guessing.
- **Stay in scope** — change only what the task needs.
- **Verify with evidence** — tests, build output, a second opinion — not "looks done."
- **Remember** — decisions, gotchas, and context carry across days.

This repo is the configuration that closes that gap. None of it is magic — it's **context engineering**: giving the model the smallest set of high-signal rules, a memory, a reviewer, and a gate, wired together so the *default* behaviour is senior.

---

## The five pillars

| Pillar | What it does | Lives in |
|---|---|---|
| **1. The Operating Loop** | A skill that makes the agent run Understand → Plan → Build → Verify → Reflect on every task, with a capability self-check and scope discipline | `skills/dev-core/` |
| **2. The Brain** | Persistent memory — a human-readable notes vault + a semantic index — captured automatically so nothing is lost between sessions | `skills/brain-capture/` + `hooks/session-journal.ps1` |
| **3. Adversarial Review** | A fresh-context subagent that tries to *refute* the work before it ships — catches the bugs the author can't see | `agents/senior-review.md` |
| **4. Hard Verification** | A Stop hook that blocks the agent from declaring "done" while tests fail | `hooks/verify-gate.ps1` |
| **5. The Commands** | Explicit, repeatable workflows: `/plan`, `/ship`, `/audit`, `/ideate` — each encoding a research-backed method | `skills/{plan,ship,audit,ideate}/` |

Plus a reference skill of **engineering fundamentals** (`skills/engineering-fundamentals/`) the model consults while planning and reviewing, and a curated set of **tools/MCPs** that extend what the agent can reach (`docs/06-tools-and-mcps.md`).

---

## What changed, concretely

Before → after, on the exact same model:

- *"add OAuth"* → it now **explores, writes a plan, names what's out of scope, and asks for a nod** before touching code.
- *"fix the bug"* → it **reproduces with a failing test, fixes the root cause, runs the suite, and shows you the output.**
- A finding it's "sure" about → a **second agent reviews the diff in a clean context and tries to break it.** (In practice this has caught real regressions before they shipped — e.g. a fix that would have logged users out mid-payment.)
- Anything it learns → **written to the brain** (vault + semantic index) so the next session already knows it.
- *"done"* → the **test gate** won't let the turn end red.

---

## Quick start

> Requires [Claude Code](https://docs.claude.com/en/docs/claude-code). The hook scripts here are PowerShell (Windows); the `.sh` equivalents are noted inline.

1. **Skills** — copy the folders you want into your skills dir:
   ```
   cp -r skills/*           ~/.claude/skills/
   cp    agents/senior-review.md  ~/.claude/agents/
   ```
2. **Hooks** — copy the scripts and merge `hooks/settings.example.json` into `~/.claude/settings.json`:
   ```
   cp hooks/*.ps1 ~/.claude/hooks/
   ```
3. **The brain (optional but recommended)** — point `brain-capture` at your notes vault and a semantic index. See `docs/03-the-brain.md`.
4. **Per-project test gate (optional)** — drop a one-line `.claude/verify.cmd` in a repo (e.g. `npm test`) to turn on the hard gate there. See `docs/05-hooks.md`.

Then just work. The Operating Loop and brain capture apply automatically; `/plan`, `/ship`, `/audit`, `/ideate` are there when you want them.

---

## The method behind it

This isn't vibes — each piece is grounded in established practice. The full write-ups (with sources) are in `docs/`:

- **`docs/01-philosophy.md`** — context engineering & the "smallest high-signal token set" idea.
- **`docs/07-the-method.md`** — the engineering loop (Pólya), simple-vs-easy (Hickey), complexity management (Ousterhout), decision reversibility (one-way/two-way doors), and the audit method (OWASP + the SmartBear/Cisco pace research).

---

## Honest limitations

- **Skills and CLAUDE.md are advisory** (~70% adherence). The *deterministic* parts are the `senior-review` subagent (a real second pass) and the `verify-gate` hook (real test output). Lean on those for anything that matters.
- **A reviewer told to find gaps will find some.** Tell it to flag only correctness/requirement issues, or it pushes you toward over-engineering.
- This is **configuration, not a different model.** It changes defaults and adds structure; it doesn't make the model smarter.

---

## Repo map

```
senior-claude/
├── README.md
├── LICENSE
├── skills/
│   ├── dev-core/                  # the senior operating loop (always-on)
│   ├── engineering-fundamentals/  # complexity, simple≠easy, principles-as-tensions
│   ├── brain-capture/             # dual-store memory discipline
│   ├── plan/                      # /plan — explore + write a plan, no code
│   ├── ship/                      # /ship — implement + verify + self-review
│   ├── audit/                     # /audit — method + checklist + severity rubric
│   └── ideate/                    # /ideate — evidence-based idea generation
├── agents/
│   └── senior-review.md           # fresh-context adversarial reviewer
├── hooks/
│   ├── session-journal.ps1        # auto work-journal at session end
│   ├── verify-gate.ps1            # block "done" until tests pass (opt-in per repo)
│   └── settings.example.json      # how to wire the hooks
└── docs/
    ├── 01-philosophy.md
    ├── 02-skills-vs-subagents-vs-hooks.md
    ├── 03-the-brain.md
    ├── 05-hooks.md
    ├── 06-tools-and-mcps.md
    └── 07-the-method.md
```

---

<div align="center">

Built by [Luka Mladjenović](https://github.com/) while shipping a real product. MIT licensed — take what's useful.

</div>
